{ buildDotnetModule, callPackage, dotnetCorePackages, fetchFromGitHub, lib, mono
}:

buildDotnetModule rec {
  name = "olympus-sharp";
  version = "22.04.16.02";

  src = fetchFromGitHub {
    owner = "EverestAPI";
    repo = "Olympus";
    rev = "1d02bcb1f1fabc6ccfefdec6262889ca7207338c";
    hash = "sha256-awrB/M9sCA9qCCo0JtCkrA2bI2wdtesmUm5IWRKVdLE=";
    fetchSubmodules = true;
  };

  # patch to make sharp run under mono
  patches = [ ./sharp-mono.patch ];

  projectFile = "sharp/Olympus.Sharp.csproj";
  nugetDeps = ./olympus-deps.nix;
  dotnet-sdk = dotnetCorePackages.sdk_5_0;
  dotnet-runtime = dotnetCorePackages.runtime_5_0;
  # if this isn't set, nix will try to link random things into $out/bin
  executables = [ ];

  installPhase = ''
    # setup sharp
    dotnetInstallHook
    mkdir $out/bin
    install -m755 ${./sharp.sh} $out/bin/sharp
    export mono=${mono}
    substituteAllInPlace $out/bin/sharp
  '';
}
