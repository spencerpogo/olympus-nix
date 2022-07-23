{ fetchFromGitHub
, lua51Packages
, lua5_1
, pkg-config }:

lua51Packages.buildLuarocksPackage {
  pname = "nfd";
  version = "scm-1";

  src = fetchFromGitHub {
    owner = "Vexatos";
    repo = "nativefiledialog";
    rev = "2f74a5758e8df9b27158d444953697bc13fe90d8";
    sha256 = "1f52mb0s9zrpsqjp10bx92wzqmy1lq7fg1fk1nd6xmv57kc3b1qv";
    fetchSubmodules = true;
  };
  # use zenity because default gtk impl just crashes
  patches = [ ./nfd-zenity.patch ];
  rockspecDir = "lua";

  extraVariables.LUA_LIBDIR = "${lua5_1}/lib";
  nativeBuildInputs = [ pkg-config ];

  fixupPhase = ''
    find $out -name nfd_zenity.so -execdir mv {} nfd.so \;
  '';

  meta = {
    homepage = "https://github.com/Alloyed/nativefiledialog/tree/master/lua";
    description =
      "A tiny, neat C library that portably invokes native file open and save dialogs.";
    license.fullName = "zlib";
  };
}
