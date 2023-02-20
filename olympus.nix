{
  callPackage,
  curlFull,
  fetchFromGitHub,
  lib,
  love,
  lua5_1,
  lua51Packages,
  makeWrapper,
  sharp,
  stdenvNoCC,
  substituteAll,
  zenity,
}: let
  nfd = callPackage ./nfd.nix {inherit zenity;};
  lua-subprocess = callPackage ./lua-subprocess.nix {};
  lsqlite3complete = callPackage ./lsqlite3complete.nix {};
in
  stdenvNoCC.mkDerivation rec {
    name = "olympus";
    version = "23.02.16.02";

    src = fetchFromGitHub {
      owner = "EverestAPI";
      repo = "Olympus";
      rev = "4f20467e0e12801ec0bd5d7e9fbc26a4c7eb9333";
      hash = "sha256-FR6KEB5T0FbKOo81U9+NLFeQ2BpjQhc1O7goXLZwCUc=";
      fetchSubmodules = true;
    };

    patches = [
      (substituteAll {
        src = ./olympus-sharp-path.patch;
        inherit sharp;
      })
    ];
    # required for correct update prompts
    postPatch = ''
      printf '%s' '${version}' > src/version.txt
    '';

    dontConfigure = true;
    dontBuild = true;
    buildInputs = [makeWrapper];

    installPhase = ''
      mkdir $out

      cp ${nfd}/lib/lua/5.1/nfd.so $out
      cp ${lua-subprocess}/lib/lua/5.1/subprocess.so $out
      cp ${lsqlite3complete}/lib/lua/5.1/lsqlite3complete.so $out
      cp -r ./src/ $out/olympus.love/

      # create bin wrapper
      mkdir -p $out/bin
      install -m755 ${./olympus.sh} $out/bin/olympus
      export love=${love}
      substituteAllInPlace $out/bin/olympus
      # curl for luajit-request
      wrapProgram $out/bin/olympus \
        --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [curlFull]}
    '';
  }
