# This file sets up a CMakeCache for a simple distribution bootstrap build.

#Enable LLVM projects and runtimes
set(LLVM_ENABLE_PROJECTS "clang;clang-tools-extra;lld" CACHE STRING "")
set(LLVM_ENABLE_RUNTIMES "compiler-rt;libcxx;libcxxabi;libunwind" CACHE STRING "")

set(LIBUNWIND_ENABLE_SHARED OFF CACHE BOOL "")
set(LIBUNWIND_INSTALL_LIBRARY OFF CACHE BOOL "")
set(LIBUNWIND_USE_COMPILER_RT ON CACHE BOOL "")

set(LIBCXXABI_ENABLE_SHARED OFF CACHE BOOL "")
set(LIBCXXABI_ENABLE_STATIC_UNWINDER ON CACHE BOOL "")
set(LIBCXXABI_INSTALL_LIBRARY OFF CACHE BOOL "")
set(LIBCXXABI_USE_COMPILER_RT ON CACHE BOOL "")
set(LIBCXXABI_USE_LLVM_UNWINDER ON CACHE BOOL "")

set(LIBCXX_ENABLE_SHARED OFF CACHE BOOL "")
set(LIBCXX_ENABLE_STATIC_ABI_LIBRARY ON CACHE BOOL "")
set(LIBCXX_USE_COMPILER_RT ON CACHE BOOL "")
set(LIBCXX_CXX_ABI "libcxxabi" CACHE STRING "")

# Only build the native target in stage1 since it is a throwaway build.
set(LLVM_TARGETS_TO_BUILD Native CACHE STRING "")

# Optimize the stage1 compiler, but don't LTO it because that wastes time.
set(CMAKE_BUILD_TYPE Release CACHE STRING "")

# Setup vendor-specific settings.
set(PACKAGE_VENDOR Popcorn2 CACHE STRING "")

# Setting up the stage2 LTO option needs to be done on the stage1 build so that
# the proper LTO library dependencies can be connected.
set(BOOTSTRAP_LLVM_ENABLE_LTO ON CACHE BOOL "")

if (NOT APPLE)
  # Since LLVM_ENABLE_LTO is ON we need a LTO capable linker
  set(BOOTSTRAP_LLVM_ENABLE_LLD ON CACHE BOOL "")
endif()

# Expose stage2 targets through the stage1 build configuration.
set(CLANG_BOOTSTRAP_TARGETS
  check-all
  check-llvm
  check-clang
  llvm-config
  test-suite
  test-depends
  llvm-test-depends
  clang-test-depends
  distribution
  install-distribution
  clang CACHE STRING "")

# Setup the bootstrap build.
set(CLANG_ENABLE_BOOTSTRAP ON CACHE BOOL "")

set(CMAKE_OSX_ARCHITECTURES x86_64 CACHE STRING "")

message(STATUS "SYSROOT_PATH is: ${CMAKE_BINARY_DIR}")

if(STAGE2_CACHE_FILE)
  set(CLANG_BOOTSTRAP_CMAKE_ARGS
    -DSYSROOT_PATH=${CMAKE_BINARY_DIR}
    -C ${STAGE2_CACHE_FILE}
    CACHE STRING "")
else()
  set(CLANG_BOOTSTRAP_CMAKE_ARGS
    -DSYSROOT_PATH=${CMAKE_BINARY_DIR}
    -C ${CMAKE_CURRENT_LIST_DIR}/DistributionPopcorn-stage2.cmake
    CACHE STRING "")
endif()

if(APPLE)
  set(CMAKE_OSX_SYSROOT "/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk" CACHE STRING "")
  set(BUILTINS_CMAKE_ARGS "-DCMAKE_OSX_SYSROOT=/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk;-DCMAKE_OSX_ARCHITECTURES=${CMAKE_OSX_ARCHITECTURES}" CACHE STRING "")
  set(RUNTIMES_CMAKE_ARGS "-DCMAKE_OSX_SYSROOT=/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk;-DCMAKE_OSX_ARCHITECTURES=${CMAKE_OSX_ARCHITECTURES}" CACHE STRING "")
endif()
