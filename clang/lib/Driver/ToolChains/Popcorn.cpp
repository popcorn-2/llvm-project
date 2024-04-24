//===--- Popcorn.cpp - Popcorn ToolChain Implementations --------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "Popcorn.h"
#include "clang/Config/config.h"
#include "clang/Driver/CommonArgs.h"
#include "clang/Driver/Compilation.h"
#include "clang/Driver/Driver.h"
#include "clang/Driver/MultilibBuilder.h"
#include "clang/Driver/SanitizerArgs.h"
#include "clang/Options/Options.h"
#include "llvm/Option/ArgList.h"
#include "llvm/Support/FileSystem.h"
#include "llvm/Support/Path.h"
#include "llvm/Support/VirtualFileSystem.h"

using namespace clang::driver;
using namespace clang::driver::toolchains;
using namespace clang::driver::tools;
using namespace clang;
using namespace llvm::opt;

using tools::addMultilibFlag;

void popcorn::Linker::ConstructJob(Compilation &C, const JobAction &JA,
                                   const InputInfo &Output,
                                   const InputInfoList &Inputs,
                                   const ArgList &Args,
                                   const char *LinkingOutput) const {
  const auto &ToolChain = static_cast<const Popcorn &>(getToolChain());
  const Driver &D = ToolChain.getDriver();

  ArgStringList CmdArgs;

  // Silence warning for "clang -g foo.o -o foo"
  Args.ClaimAllArgs(options::OPT_g_Group);
  // and "clang -emit-llvm foo.o -o foo"
  Args.ClaimAllArgs(options::OPT_emit_llvm);
  // and for "clang -w foo.o -o foo". Other warning options are already
  // handled somewhere else.
  Args.ClaimAllArgs(options::OPT_w);

  CmdArgs.push_back("-z");
  CmdArgs.push_back("max-page-size=4096");

  const char *Exec = Args.MakeArgString(ToolChain.GetLinkerPath());

  if (!D.SysRoot.empty())
    CmdArgs.push_back(Args.MakeArgString("--sysroot=" + D.SysRoot));

  if (Args.hasArg(options::OPT_s))
    CmdArgs.push_back("-s");

  if (Args.hasArg(options::OPT_r)) {
    CmdArgs.push_back("-r");
  } else {
    CmdArgs.push_back("--build-id");
    CmdArgs.push_back("--hash-style=gnu");
  }

  CmdArgs.push_back("--eh-frame-hdr");

  if (Args.hasArg(options::OPT_static))
    CmdArgs.push_back("-Bstatic");
  else if (Args.hasArg(options::OPT_shared))
    CmdArgs.push_back("-shared");

  if (!Args.hasArg(options::OPT_static) || Args.hasArg(options::OPT_shared) || Args.hasArg(options::OPT_r)) {
    std::string Dyld = D.DyldPrefix;
    Dyld += "dyld.elf.1";
    CmdArgs.push_back("-dynamic-linker");
    CmdArgs.push_back(Args.MakeArgString(Dyld));
  }

  CmdArgs.push_back("-o");
  CmdArgs.push_back(Output.getFilename());

  if (!Args.hasArg(options::OPT_nostdlib, options::OPT_nostartfiles,
                   options::OPT_r)) {
    CmdArgs.push_back(Args.MakeArgString(ToolChain.GetFilePath("crt1.o")));
    CmdArgs.push_back(Args.MakeArgString(ToolChain.GetFilePath("librt_elf.a")));
  }

  Args.addAllArgs(CmdArgs, {options::OPT_L, options::OPT_u});

  ToolChain.AddFilePathLibArgs(Args, CmdArgs);

  if (D.isUsingLTO())
    addLTOOptions(ToolChain, Args, CmdArgs, Output, Inputs,
                  D.getLTOMode() == LTOK_Thin);

  addLinkerCompressDebugSectionsOption(ToolChain, Args, CmdArgs);
  AddLinkerInputs(ToolChain, Inputs, Args, CmdArgs, JA);

  // Sample these options first so they are claimed even under -nostdlib et al.
  bool NoLibc = Args.hasArg(options::OPT_nolibc);
  bool OnlyLibstdcxxStatic = Args.hasArg(options::OPT_static_libstdcxx) &&
                             !Args.hasArg(options::OPT_static);
  
  if (!Args.hasArg(options::OPT_nostdlib, options::OPT_nodefaultlibs,
                   options::OPT_r)) {

    if (D.CCCIsCXX()) {
      if (ToolChain.ShouldLinkCXXStdlib(Args)) {
        CmdArgs.push_back("--push-state");
        CmdArgs.push_back("--as-needed");
        if (OnlyLibstdcxxStatic)
          CmdArgs.push_back("-Bstatic");
        ToolChain.AddCXXStdlibLibArgs(Args, CmdArgs);
        if (OnlyLibstdcxxStatic)
          CmdArgs.push_back("-Bdynamic");
        CmdArgs.push_back("--pop-state");
      }
    }

    ToolChain.addProfileRTLibs(Args, CmdArgs);

    AddRunTimeLibs(ToolChain, D, CmdArgs, Args);

    if (!NoLibc)
      CmdArgs.push_back("-lc");
  }

  C.addCommand(std::make_unique<Command>(JA, *this,
                                         ResponseFileSupport::AtFileCurCP(),
                                         Exec, CmdArgs, Inputs, Output));
}

/// Popcorn - Popcorn tool chain which can call as(1) and ld(1) directly.

Popcorn::Popcorn(const Driver &D, const llvm::Triple &Triple,
                 const ArgList &Args)
    : ToolChain(D, Triple, Args) {
  getProgramPaths().push_back(getDriver().Dir);

  if (!D.SysRoot.empty()) {
    SmallString<128> P(D.SysRoot);
    llvm::sys::path::append(P, "system", "lib");
    getFilePaths().push_back(std::string(P));
  }
}

std::string Popcorn::ComputeEffectiveClangTriple(const ArgList &Args,
                                                 types::ID InputType) const {
  llvm::Triple Triple(ComputeLLVMTriple(Args, InputType));
  return Triple.str();
}

Tool *Popcorn::buildLinker() const { return new tools::popcorn::Linker(*this); }

ToolChain::RuntimeLibType
Popcorn::GetRuntimeLibType(const ArgList &Args) const {
  if (Arg *A = Args.getLastArg(options::OPT_rtlib_EQ)) {
    StringRef Value = A->getValue();
    if (Value != "compiler-rt")
      getDriver().Diag(clang::diag::err_drv_invalid_rtlib_name)
          << A->getAsString(Args);
  }

  return ToolChain::RLT_CompilerRT;
}

ToolChain::CXXStdlibType Popcorn::GetCXXStdlibType(const ArgList &Args) const {
  if (Arg *A = Args.getLastArg(options::OPT_stdlib_EQ)) {
    StringRef Value = A->getValue();
    if (Value != "libc++")
      getDriver().Diag(diag::err_drv_invalid_stdlib_name)
          << A->getAsString(Args);
  }

  return ToolChain::CST_Libcxx;
}

void Popcorn::addClangTargetOptions(const ArgList &DriverArgs,
                                    ArgStringList &CC1Args,
                                    Action::OffloadKind) const {
  CC1Args.push_back("-ffunction-sections");
  CC1Args.push_back("-fdata-sections");
}

void Popcorn::AddClangSystemIncludeArgs(const ArgList &DriverArgs,
                                        ArgStringList &CC1Args) const {
  const Driver &D = getDriver();

  if (DriverArgs.hasArg(options::OPT_nostdinc))
    return;

  if (!DriverArgs.hasArg(options::OPT_nobuiltininc)) {
    SmallString<128> P(D.ResourceDir);
    llvm::sys::path::append(P, "include");
    addSystemInclude(DriverArgs, CC1Args, P);
  }

  if (DriverArgs.hasArg(options::OPT_nostdlibinc))
    return;

  // Check for configure-time C include directories.
  StringRef CIncludeDirs(C_INCLUDE_DIRS);
  if (CIncludeDirs != "") {
    SmallVector<StringRef, 5> dirs;
    CIncludeDirs.split(dirs, ":");
    for (StringRef dir : dirs) {
      StringRef Prefix =
          llvm::sys::path::is_absolute(dir) ? "" : StringRef(D.SysRoot);
      addExternCSystemInclude(DriverArgs, CC1Args, Prefix + dir);
    }
    return;
  }

  if (!D.SysRoot.empty()) {
    SmallString<128> P(D.SysRoot);
    llvm::sys::path::append(P, "system", "include");
    addExternCSystemInclude(DriverArgs, CC1Args, P.str());
  }
}

void Popcorn::AddClangCXXStdlibIncludeArgs(const ArgList &DriverArgs,
                                           ArgStringList &CC1Args) const {
if (DriverArgs.hasArg(options::OPT_nostdlibinc) ||
      DriverArgs.hasArg(options::OPT_nostdincxx))
    return;

  switch (GetCXXStdlibType(DriverArgs)) {
  case ToolChain::CST_Libcxx: {
    SmallString<128> P(getDriver().SysRoot);
    llvm::sys::path::append(P, "system", "include", "c++", "v1");
    addSystemInclude(DriverArgs, CC1Args, P.str());
    break;
  }

  default:
    llvm_unreachable("invalid stdlib name");
  }
}

void Popcorn::AddCXXStdlibLibArgs(const ArgList &Args,
                                  ArgStringList &CmdArgs) const {
  switch (GetCXXStdlibType(Args)) {
  case ToolChain::CST_Libcxx:
    CmdArgs.push_back("-lc++");
    CmdArgs.push_back("-lc++abi");
    if (Args.hasArg(options::OPT_fexperimental_library))
      CmdArgs.push_back("-lc++experimental");
    break;

  case ToolChain::CST_Libstdcxx:
    llvm_unreachable("invalid stdlib name");
  }
}

SanitizerMask Popcorn::getSupportedSanitizers() const {
  SanitizerMask Res = ToolChain::getSupportedSanitizers();
  /*Res |= SanitizerKind::Address;
  Res |= SanitizerKind::HWAddress;
  Res |= SanitizerKind::PointerCompare;
  Res |= SanitizerKind::PointerSubtract;
  Res |= SanitizerKind::Fuzzer;
  Res |= SanitizerKind::FuzzerNoLink;
  Res |= SanitizerKind::Leak;
  Res |= SanitizerKind::SafeStack;
  Res |= SanitizerKind::Scudo;
  Res |= SanitizerKind::Thread;*/
  return Res;
}

SanitizerMask Popcorn::getDefaultSanitizers() const {
  SanitizerMask Res;
  switch (getTriple().getArch()) {
  default:
    break;
  }
  return Res;
}
