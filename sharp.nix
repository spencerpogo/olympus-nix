{
  buildDotnetModule,
  callPackage,
  dotnetCorePackages,
  fetchFromGitHub,
  lib,
  mono,
}:
let 
  inherit (callPackage ./dotnet-5.0.nix {}) sdk_5_0 runtime_5_0;
in buildDotnetModule rec {
  name = "olympus-sharp";
  version = "23.02.16.02";

  src = fetchFromGitHub {
    owner = "EverestAPI";
    repo = "Olympus";
    rev = "4f20467e0e12801ec0bd5d7e9fbc26a4c7eb9333";
    hash = "sha256-FR6KEB5T0FbKOo81U9+NLFeQ2BpjQhc1O7goXLZwCUc=";
    fetchSubmodules = true;
  };

  # patch to make sharp run under mono
  patches = [./sharp-mono.patch];

  projectFile = "sharp/Olympus.Sharp.csproj";
  nugetDeps = ./olympus-deps.nix;
  dotnet-sdk = sdk_5_0;
  dotnet-runtime = runtime_5_0;
  # if this isn't set, nix will try to link random things into $out/bin
  executables = [];

  installPhase = ''
    # setup sharp
    dotnetInstallHook
    mkdir $out/bin
    install -m755 ${./sharp.sh} $out/bin/sharp
    export mono=${mono}
    substituteAllInPlace $out/bin/sharp
  '';
}
