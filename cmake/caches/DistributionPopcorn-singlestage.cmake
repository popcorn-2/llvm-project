# This file sets up a CMakeCache for a simple distribution bootstrap build.

#Enable LLVM projects and runtimes
set(LLVM_ENABLE_PROJECTS "clang;clang-tools-extra;lld" CACHE STRING "")
set(LLVM_ENABLE_RUNTIMES "compiler-rt;libcxx;libcxxabi;libunwind" CACHE STRING "")

set(CLANG_DEFAULT_CXX_STDLIB libc++ CACHE STRING "")
set(CLANG_DEFAULT_LINKER lld CACHE STRING "")
set(CLANG_DEFAULT_OBJCOPY llvm-objcopy CACHE STRING "")
set(CLANG_DEFAULT_RTLIB compiler-rt CACHE STRING "")
set(CLANG_DEFAULT_UNWINDLIB libunwind CACHE STRING "")

set(CMAKE_INSTALL_PREFIX ${CMAKE_BINARY_DIR}/../pkg/toolchain CACHE STRING "")

set(RUNTIMES_default_LLVM_ENABLE_RUNTIMES "compiler-rt;libcxx;libcxxabi;libunwind" CACHE STRING "")
set(RUNTIMES_x86_64-unknown-popcorn_LLVM_ENABLE_RUNTIMES "compiler-rt;libunwind" CACHE STRING "")

set(BUILTINS_x86_64-unknown-popcorn_CMAKE_SYSTEM_NAME Linux CACHE STRING "")
set(BUILTINS_x86_64-unknown-popcorn_CMAKE_C_FLAGS "--target=x86_64-unknown-popcorn --sysroot=${POPCORN_SYSROOT}" CACHE STRING "")
set(BUILTINS_x86_64-unknown-popcorn_CMAKE_CXX_FLAGS "--target=x86_64-unknown-popcorn --sysroot=${POPCORN_SYSROOT}" CACHE STRING "")
set(BUILTINS_x86_64-unknown-popcorn_CMAKE_EXE_LINKER_FLAGS "--target=x86_64-unknown-popcorn --sysroot=${POPCORN_SYSROOT}" CACHE STRING "")
set(BUILTINS_x86_64-unknown-popcorn_CMAKE_SHARED_LINKER_FLAGS "--target=x86_64-unknown-popcorn --sysroot=${POPCORN_SYSROOT}" CACHE STRING "")
set(BUILTINS_x86_64-unknown-popcorn_CMAKE_MODULE_LINKER_FLAGS "--target=x86_64-unknown-popcorn --sysroot=${POPCORN_SYSROOT}" CACHE STRING "")
set(BUILTINS_x86_64-unknown-popcorn_SYSROOT "${POPCORN_SYSROOT}")
set(RUNTIMES_x86_64-unknown-popcorn_CMAKE_SYSTEM_NAME Linux CACHE STRING "")
set(RUNTIMES_x86_64-unknown-popcorn_CMAKE_C_FLAGS "--target=x86_64-unknown-popcorn --sysroot=${POPCORN_SYSROOT}" CACHE STRING "")
set(RUNTIMES_x86_64-unknown-popcorn_CMAKE_CXX_FLAGS "--target=x86_64-unknown-popcorn --sysroot=${POPCORN_SYSROOT}" CACHE STRING "")
set(RUNTIMES_x86_64-unknown-popcorn_CMAKE_EXE_LINKER_FLAGS "--target=x86_64-unknown-popcorn --sysroot=${POPCORN_SYSROOT}" CACHE STRING "")
set(RUNTIMES_x86_64-unknown-popcorn_CMAKE_SHARED_LINKER_FLAGS "--target=x86_64-unknown-popcorn --sysroot=${POPCORN_SYSROOT}" CACHE STRING "")
set(RUNTIMES_x86_64-unknown-popcorn_CMAKE_MODULE_LINKER_FLAGS "--target=x86_64-unknown-popcorn --sysroot=${POPCORN_SYSROOT}" CACHE STRING "")
set(RUNTIMES_x86_64-unknown-popcorn_SYSROOT "${POPCORN_SYSROOT}")

foreach(target default;x86_64-unknown-popcorn)
	list(APPEND BUILTIN_TARGETS ${target})
	list(APPEND RUNTIME_TARGETS ${target})

	set(RUNTIMES_${target}_LIBUNWIND_ENABLE_SHARED OFF CACHE BOOL "")
	set(RUNTIMES_${target}_LIBUNWIND_INSTALL_LIBRARY ON CACHE BOOL "")
	set(RUNTIMES_${target}_LIBUNWIND_USE_COMPILER_RT ON CACHE BOOL "")

	set(RUNTIMES_${target}_COMPILER_RT_BUILD_BUILTINS ON CACHE BOOL "")
	set(RUNTIMES_${target}_COMPILER_RT_BUILD_LIBFUZZER OFF CACHE BOOL "")
	set(RUNTIMES_${target}_COMPILER_RT_BUILD_MEMPROF OFF CACHE BOOL "")
	set(RUNTIMES_${target}_COMPILER_RT_BUILD_PROFILE OFF CACHE BOOL "")
	set(RUNTIMES_${target}_COMPILER_RT_BUILD_SANITIZERS OFF CACHE BOOL "")
	set(RUNTIMES_${target}_COMPILER_RT_BUILD_XRAY OFF CACHE BOOL "")

	set(RUNTIMES_${target}_LIBCXXABI_ENABLE_SHARED OFF CACHE BOOL "")
	set(RUNTIMES_${target}_LIBCXXABI_ENABLE_STATIC_UNWINDER ON CACHE BOOL "")
	set(RUNTIMES_${target}_LIBCXXABI_INSTALL_LIBRARY OFF CACHE BOOL "")
	set(RUNTIMES_${target}_LIBCXXABI_USE_COMPILER_RT ON CACHE BOOL "")
	set(RUNTIMES_${target}_LIBCXXABI_USE_LLVM_UNWINDER ON CACHE BOOL "")
	set(RUNTIMES_${target}_LIBCXXABI_LINK_TESTS_WITH_SHARED_LIBCXXABI OFF CACHE BOOL "")

	set(RUNTIMES_${target}_LIBCXX_ENABLE_SHARED OFF CACHE BOOL "")
	set(RUNTIMES_${target}_LIBCXX_ENABLE_STATIC_ABI_LIBRARY ON CACHE BOOL "")
	set(RUNTIMES_${target}_LIBCXX_USE_COMPILER_RT ON CACHE BOOL "")
	set(RUNTIMES_${target}_LIBCXX_CXX_ABI "libcxxabi" CACHE STRING "")
	set(RUNTIMES_${target}_LIBCXX_LINK_TESTS_WITH_SHARED_LIBCXX OFF CACHE BOOL "")

	set(RUNTIMES_${target}_COMPILER_RT_BUILD_CRT OFF CACHE BOOL "")
	set(RUNTIMES_${target}_COMPILER_RT_BUILD_CTX_PROFILE OFF CACHE BOOL "")
	set(RUNTIMES_${target}_COMPILER_RT_BUILD_GWP_ASAN OFF CACHE BOOL "")
	set(RUNTIMES_${target}_COMPILER_RT_BUILD_ORC OFF CACHE BOOL "")

	set(BUILTINS_${target}_COMPILER_RT_BUILD_CRT OFF CACHE BOOL "")

	set(BUILTINS_${target}_CMAKE_INSTALL_PREFIX "${CMAKE_BINARY_DIR}/../pkg/toolchain" CACHE PATH "")
endforeach()

set(RUNTIMES_x86_64-unknown-popcorn_CMAKE_INSTALL_PREFIX "${CMAKE_BINARY_DIR}/../pkg/sysroot_new/system" CACHE PATH "")
set(RUNTIMES_default_CMAKE_INSTALL_PREFIX "${CMAKE_BINARY_DIR}/../pkg/toolchain" CACHE PATH "")

set(LLVM_BUILTIN_TARGETS "${BUILTIN_TARGETS}" CACHE STRING "")
set(LLVM_RUNTIME_TARGETS "${RUNTIME_TARGETS}" CACHE STRING "")

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
  ${LLVM_TOOLCHAIN_TOOLS}
  CACHE STRING "")
