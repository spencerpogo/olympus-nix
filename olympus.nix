{ callPackage, curlFull, fetchFromGitHub, lib, love, lua5_1, lua51Packages
, makeWrapper, sharp, stdenvNoCC, substituteAll, zenity }:

let
  nfd = callPackage ./nfd.nix { inherit zenity; };
  lua-subprocess = callPackage ./lua-subprocess.nix { };
  lsqlite3complete = callPackage ./lsqlite3complete.nix { };
in stdenvNoCC.mkDerivation rec {
  name = "olympus";
  version = "22.04.16.02";

  src = fetchFromGitHub {
    owner = "EverestAPI";
    repo = "Olympus";
    rev = "9b8043c180c0602b5c24ce24c092a124c6b70dbf";
    hash = "sha256-Nj/aFoFdP2aED492e++u/tfLqNE+DgWWNyNSM3aykf4=";
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
  buildInputs = [ makeWrapper ];

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
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ curlFull ]}
  '';
}
