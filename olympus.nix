{ buildDotnetModule, callPackage, curlFull, dotnetCorePackages, fetchFromGitHub
, lib, love, lua5_1, lua51Packages, mono, zip, zenity }:

let
  nfd = callPackage ./nfd.nix { inherit zenity; };
  lua-subprocess = callPackage ./lua-subprocess.nix { };
  lsqlite3complete = callPackage ./lsqlite3complete.nix { };
in buildDotnetModule rec {
  name = "olympus";
  version = "22.04.16.02";

  src = fetchFromGitHub {
    owner = "EverestAPI";
    repo = "Olympus";
    rev = "1d02bcb1f1fabc6ccfefdec6262889ca7207338c";
    hash = "sha256-awrB/M9sCA9qCCo0JtCkrA2bI2wdtesmUm5IWRKVdLE=";
    fetchSubmodules = true;
  };

  # patch to make sharp run under mono
  patches = [ ./olympus-sharp-mono.patch ];
  # required for correct update prompts
  postPatch = ''
    printf '%s' '${version}' > src/version.txt
  '';

  projectFile = "sharp/Olympus.Sharp.csproj";
  nugetDeps = ./olympus-deps.nix;
  dotnet-sdk = dotnetCorePackages.sdk_5_0;
  dotnet-runtime = dotnetCorePackages.runtime_5_0;
  # if this isn't set, nix will try to link random things into $out/bin
  executables = [ ];

  buildInputs =
    [ lua5_1 lua51Packages.luarocks nfd lua-subprocess lsqlite3complete zip ];

  installPhase = ''
    # setup sharp
    dotnetInstallHook
    mv $out/lib $out/sharp
    install -m755 ${./sharp.sh} $out/sharp/Olympus.Sharp.bin.x86_64
    export mono=${mono}
    substituteAllInPlace $out/sharp/Olympus.Sharp.bin.x86_64

    # copy lua deps
    cp ${nfd}/lib/lua/5.1/nfd.so $out
    cp ${lua-subprocess}/lib/lua/5.1/subprocess.so $out
    cp ${lsqlite3complete}/lib/lua/5.1/lsqlite3complete.so $out

    # build love zip
    cd src
    zip -r $out/olympus.love .

    # create bin wrapper
    mkdir -p $out/bin
    install -m755 ${./olympus.sh} $out/bin/olympus
    export love=${love}
    substituteAllInPlace $out/bin/olympus
    wrapProgram $out/bin/olympus \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ curlFull ]}
  '';
}
