# This file sets up a CMakeCache for a simple distribution bootstrap build.

#Enable LLVM projects and runtimes
set(LLVM_ENABLE_PROJECTS "clang;clang-tools-extra;lld" CACHE STRING "")
set(LLVM_ENABLE_RUNTIMES "compiler-rt;libcxx;libcxxabi;libunwind" CACHE STRING "")

set(CLANG_DEFAULT_CXX_STDLIB libc++ CACHE STRING "")
set(CLANG_DEFAULT_LINKER lld CACHE STRING "")
set(CLANG_DEFAULT_OBJCOPY llvm-objcopy CACHE STRING "")
set(CLANG_DEFAULT_RTLIB compiler-rt CACHE STRING "")
set(CLANG_DEFAULT_UNWINDLIB libunwind CACHE STRING "")

set(LIBUNWIND_ENABLE_SHARED OFF CACHE BOOL "")
set(LIBUNWIND_INSTALL_LIBRARY ON CACHE BOOL "")
set(LIBUNWIND_USE_COMPILER_RT ON CACHE BOOL "")

list(APPEND BUILTIN_TARGETS "default")
list(APPEND BUILTIN_TARGETS "x86_64-unknown-popcorn")
list(APPEND RUNTIME_TARGETS "default")
list(APPEND RUNTIME_TARGETS "x86_64-unknown-popcorn")
set(RUNTIMES_default_LLVM_ENABLE_RUNTIMES "compiler-rt;libcxx;libcxxabi;libunwind" CACHE STRING "")
set(RUNTIMES_x86_64-unknown-popcorn_LLVM_ENABLE_RUNTIMES "compiler-rt;libunwind" CACHE STRING "")

set(BUILTINS_x86_64-unknown-popcorn_CMAKE_SYSTEM_NAME Generic CACHE STRING "")
set(BUILTINS_x86_64-unknown-popcorn_CMAKE_C_FLAGS "--target=x86_64-unknown-popcorn --sysroot=${POPCORN_SYSROOT}" CACHE STRING "")
set(BUILTINS_x86_64-unknown-popcorn_CMAKE_CXX_FLAGS "--target=x86_64-unknown-popcorn --sysroot=${POPCORN_SYSROOT}" CACHE STRING "")
set(BUILTINS_x86_64-unknown-popcorn_CMAKE_EXE_LINKER_FLAGS "--target=x86_64-unknown-popcorn --sysroot=${POPCORN_SYSROOT}" CACHE STRING "")
set(BUILTINS_x86_64-unknown-popcorn_CMAKE_SHARED_LINKER_FLAGS "--target=x86_64-unknown-popcorn --sysroot=${POPCORN_SYSROOT}" CACHE STRING "")
set(BUILTINS_x86_64-unknown-popcorn_CMAKE_MODULE_LINKER_FLAGS "--target=x86_64-unknown-popcorn --sysroot=${POPCORN_SYSROOT}" CACHE STRING "")
set(BUILTINS_x86_64-unknown-popcorn_SYSROOT "${POPCORN_SYSROOT}")
set(RUNTIMES_x86_64-unknown-popcorn_CMAKE_SYSTEM_NAME Popcorn CACHE STRING "")
set(RUNTIMES_x86_64-unknown-popcorn_CMAKE_C_FLAGS "--target=x86_64-unknown-popcorn --sysroot=${POPCORN_SYSROOT}" CACHE STRING "")
set(RUNTIMES_x86_64-unknown-popcorn_CMAKE_CXX_FLAGS "--target=x86_64-unknown-popcorn --sysroot=${POPCORN_SYSROOT}" CACHE STRING "")
set(RUNTIMES_x86_64-unknown-popcorn_CMAKE_EXE_LINKER_FLAGS "--target=x86_64-unknown-popcorn --sysroot=${POPCORN_SYSROOT}" CACHE STRING "")
set(RUNTIMES_x86_64-unknown-popcorn_CMAKE_SHARED_LINKER_FLAGS "--target=x86_64-unknown-popcorn --sysroot=${POPCORN_SYSROOT}" CACHE STRING "")
set(RUNTIMES_x86_64-unknown-popcorn_CMAKE_MODULE_LINKER_FLAGS "--target=x86_64-unknown-popcorn --sysroot=${POPCORN_SYSROOT}" CACHE STRING "")
set(RUNTIMES_x86_64-unknown-popcorn_SYSROOT "${POPCORN_SYSROOT}")

set(BUILTINS_CMAKE_INSTALL_PREFIX "${CMAKE_BINARY_DIR}/../toolchain" CACHE PATH "")

set(RUNTIMES_x86_64-unknown-popcorn_CMAKE_INSTALL_PREFIX "${CMAKE_BINARY_DIR}/../sysroot_new/system" CACHE PATH "")
set(RUNTIMES_default_CMAKE_INSTALL_PREFIX "${CMAKE_BINARY_DIR}/../toolchain" CACHE PATH "")

set(LLVM_BUILTIN_TARGETS "${BUILTIN_TARGETS}" CACHE STRING "")
set(LLVM_RUNTIME_TARGETS "${RUNTIME_TARGETS}" CACHE STRING "")

set(COMPILER_RT_BUILD_BUILTINS ON CACHE BOOL "")
set(COMPILER_RT_BUILD_LIBFUZZER OFF CACHE BOOL "")
set(COMPILER_RT_BUILD_MEMPROF OFF CACHE BOOL "")
set(COMPILER_RT_BUILD_PROFILE OFF CACHE BOOL "")
set(COMPILER_RT_BUILD_SANITIZERS OFF CACHE BOOL "")
set(COMPILER_RT_BUILD_XRAY OFF CACHE BOOL "")

set(LLVM_TARGETS_TO_BUILD "Native;X86" CACHE STRING "")

set(CMAKE_BUILD_TYPE RelWithDebInfo CACHE STRING "")
set(CMAKE_C_FLAGS_RELWITHDEBINFO "-O3 -gline-tables-only -DNDEBUG" CACHE STRING "")
set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "-O3 -gline-tables-only -DNDEBUG" CACHE STRING "")
set(LLVM_ENABLE_LTO ON CACHE BOOL "")

# Setup vendor-specific settings.
set(PACKAGE_VENDOR Popcorn2 CACHE STRING "")

# Setting up the stage2 LTO option needs to be done on the stage1 build so that
# the proper LTO library dependencies can be connected.
set(LLVM_ENABLE_LTO ON CACHE BOOL "")

set(CMAKE_OSX_ARCHITECTURES x86_64 CACHE STRING "")

if(APPLE)
  set(CMAKE_OSX_SYSROOT "/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk" CACHE STRING "")
  set(BUILTINS_CMAKE_ARGS "-DCMAKE_OSX_SYSROOT=/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk;-DCMAKE_OSX_ARCHITECTURES=${CMAKE_OSX_ARCHITECTURES}" CACHE STRING "")
  set(RUNTIMES_CMAKE_ARGS "-DCMAKE_OSX_SYSROOT=/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk;-DCMAKE_OSX_ARCHITECTURES=${CMAKE_OSX_ARCHITECTURES}" CACHE STRING "")
endif()

# setup toolchain
set(LLVM_INSTALL_TOOLCHAIN_ONLY ON CACHE BOOL "")
set(LLVM_TOOLCHAIN_TOOLS
  dsymutil
  llvm-cov
  llvm-dwarfdump
  llvm-profdata
  llvm-objdump
  llvm-nm
  llvm-size
  llvm-ar
  llvm-config
  llvm-ranlib
  CACHE STRING "")

set(LLVM_DISTRIBUTION_COMPONENTS
  clang
  LTO
  clang-format
  clang-resource-headers
  lld
  builtins
  runtimes
  ${LLVM_TOOLCHAIN_TOOLS}
  CACHE STRING "")
