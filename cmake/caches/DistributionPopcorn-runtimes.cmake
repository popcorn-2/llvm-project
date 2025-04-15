# This file sets up a CMakeCache for the second stage of a simple distribution
# bootstrap build.

set(LLVM_ENABLE_PROJECTS "clang" CACHE STRING "")

set(PACKAGE_VENDOR Popcorn CACHE STRING "")

set(CMAKE_C_COMPILER ${CMAKE_BINARY_DIR}/../toolchain/bin/clang CACHE STRING "")
set(CMAKE_CXX_COMPILER ${CMAKE_BINARY_DIR}/../toolchain/bin/clang++ CACHE STRING "")
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY CACHE STRING "")
set(HAVE_LIBRT FALSE CACHE BOOL "")

set(LIBUNWIND_ENABLE_SHARED OFF CACHE BOOL "")
set(LIBUNWIND_INSTALL_LIBRARY OFF CACHE BOOL "")
set(LIBUNWIND_USE_COMPILER_RT ON CACHE BOOL "")

set(LIBCXXABI_ENABLE_SHARED OFF CACHE BOOL "")
set(LIBCXXABI_ENABLE_STATIC_UNWINDER ON CACHE BOOL "")
set(LIBCXXABI_INSTALL_LIBRARY OFF CACHE BOOL "")
set(LIBCXXABI_USE_COMPILER_RT ON CACHE BOOL "")
set(LIBCXXABI_USE_LLVM_UNWINDER ON CACHE BOOL "")
set(LIBCXXABI_LINK_TESTS_WITH_SHARED_LIBCXXABI OFF CACHE BOOL "")

set(LIBCXX_ENABLE_SHARED OFF CACHE BOOL "")
set(LIBCXX_ENABLE_STATIC_ABI_LIBRARY ON CACHE BOOL "")
set(LIBCXX_USE_COMPILER_RT ON CACHE BOOL "")
set(LIBCXX_CXX_ABI "libcxxabi" CACHE STRING "")
set(LIBCXX_LINK_TESTS_WITH_SHARED_LIBCXX OFF CACHE BOOL "")

set(LIBUNWIND_INSTALL_LIBRARY ON CACHE BOOL "")
set(LIBCXXABI_INSTALL_LIBRARY ON CACHE BOOL "")
set(LIBCXX_INSTALL_LIBRARY ON CACHE BOOL "")

list(APPEND BUILTIN_TARGETS "default")
list(APPEND BUILTIN_TARGETS "x86_64-unknown-popcorn")
list(APPEND RUNTIME_TARGETS "default")
list(APPEND RUNTIME_TARGETS "x86_64-unknown-popcorn")
set(RUNTIMES_default_LLVM_ENABLE_RUNTIMES "compiler-rt;libcxx;libcxxabi;libunwind" CACHE STRING "")
set(RUNTIMES_x86_64-unknown-popcorn_LLVM_ENABLE_RUNTIMES "compiler-rt;libunwind" CACHE STRING "")

set(BUILTINS_x86_64-unknown-popcorn_CMAKE_SYSTEM_NAME Popcorn CACHE STRING "")
set(BUILTINS_x86_64-unknown-popcorn_CMAKE_C_FLAGS "--target=x86_64-unknown-popcorn --sysroot=${CMAKE_BINARY_DIR}/../sysroot" CACHE STRING "")
set(BUILTINS_x86_64-unknown-popcorn_CMAKE_CXX_FLAGS "--target=x86_64-unknown-popcorn --sysroot=${CMAKE_BINARY_DIR}/../sysroot" CACHE STRING "")
set(BUILTINS_x86_64-unknown-popcorn_CMAKE_EXE_LINKER_FLAGS "--target=x86_64-unknown-popcorn --sysroot=${CMAKE_BINARY_DIR}/../sysroot" CACHE STRING "")
set(BUILTINS_x86_64-unknown-popcorn_CMAKE_SHARED_LINKER_FLAGS "--target=x86_64-unknown-popcorn --sysroot=${CMAKE_BINARY_DIR}/../sysroot" CACHE STRING "")
set(BUILTINS_x86_64-unknown-popcorn_CMAKE_MODULE_LINKER_FLAGS "--target=x86_64-unknown-popcorn --sysroot=${CMAKE_BINARY_DIR}/../sysroot" CACHE STRING "")
set(BUILTINS_x86_64-unknown-popcorn_SYSROOT "${CMAKE_BINARY_DIR}/../sysroot")
set(RUNTIMES_x86_64-unknown-popcorn_CMAKE_SYSTEM_NAME Popcorn CACHE STRING "")
set(RUNTIMES_x86_64-unknown-popcorn_CMAKE_C_FLAGS "--target=x86_64-unknown-popcorn --sysroot=${CMAKE_BINARY_DIR}/../sysroot" CACHE STRING "")
set(RUNTIMES_x86_64-unknown-popcorn_CMAKE_CXX_FLAGS "--target=x86_64-unknown-popcorn --sysroot=${CMAKE_BINARY_DIR}/../sysroot" CACHE STRING "")
set(RUNTIMES_x86_64-unknown-popcorn_CMAKE_EXE_LINKER_FLAGS "--target=x86_64-unknown-popcorn --sysroot=${CMAKE_BINARY_DIR}/../sysroot" CACHE STRING "")
set(RUNTIMES_x86_64-unknown-popcorn_CMAKE_SHARED_LINKER_FLAGS "--target=x86_64-unknown-popcorn --sysroot=${CMAKE_BINARY_DIR}/../sysroot" CACHE STRING "")
set(RUNTIMES_x86_64-unknown-popcorn_CMAKE_MODULE_LINKER_FLAGS "--target=x86_64-unknown-popcorn --sysroot=${CMAKE_BINARY_DIR}/../sysroot" CACHE STRING "")
set(RUNTIMES_x86_64-unknown-popcorn_SYSROOT "${CMAKE_BINARY_DIR}/../sysroot")

# Install compiler-rt (libclang_rt) into toolchain
set(BUILTINS_CMAKE_INSTALL_PREFIX "${CMAKE_BINARY_DIR}/../toolchain" CACHE PATH "")

# Install libc++, libc++abi, libunwind into sysroot
set(RUNTIMES_x86_64-unknown-popcorn_CMAKE_INSTALL_PREFIX "${CMAKE_BINARY_DIR}/../sysroot/system" CACHE PATH "")
set(RUNTIMES_default_CMAKE_INSTALL_PREFIX "${CMAKE_BINARY_DIR}/../toolchain" CACHE PATH "")


set(LLVM_BUILTIN_TARGETS "${BUILTIN_TARGETS}" CACHE STRING "")
set(LLVM_RUNTIME_TARGETS "${RUNTIME_TARGETS}" CACHE STRING "")

set(COMPILER_RT_BUILD_BUILTINS ON CACHE BOOL "")
set(COMPILER_RT_BUILD_LIBFUZZER OFF CACHE BOOL "")
set(COMPILER_RT_BUILD_MEMPROF OFF CACHE BOOL "")
set(COMPILER_RT_BUILD_PROFILE OFF CACHE BOOL "")
set(COMPILER_RT_BUILD_SANITIZERS OFF CACHE BOOL "")
set(COMPILER_RT_BUILD_XRAY OFF CACHE BOOL "")

set(LLVM_ENABLE_LLD ON CACHE BOOL "")

set(LLVM_TARGETS_TO_BUILD Native;X86 CACHE STRING "")

set(CMAKE_BUILD_TYPE RelWithDebInfo CACHE STRING "")
set(CMAKE_C_FLAGS_RELWITHDEBINFO "-O3 -gline-tables-only -DNDEBUG" CACHE STRING "")
set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "-O3 -gline-tables-only -DNDEBUG" CACHE STRING "")

# setup toolchain
set(LLVM_INSTALL_TOOLCHAIN_ONLY ON CACHE BOOL "")

set(LLVM_DISTRIBUTION_COMPONENTS
  builtins
  runtimes
  CACHE STRING "")

# For Apple, explicitly set the sysroot
if(APPLE)
  set(BUILTINS_default_CMAKE_ARGS "-DCMAKE_OSX_SYSROOT=/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk;-DCMAKE_OSX_ARCHITECTURES=x86_64" CACHE STRING "")
  set(RUNTIMES_default_CMAKE_ARGS "-DCMAKE_OSX_SYSROOT=/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk;-DCMAKE_OSX_ARCHITECTURES=x86_64" CACHE STRING "")
endif()
