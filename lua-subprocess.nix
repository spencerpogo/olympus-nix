{ fetchFromGitHub, lib, lua51Packages }:

lua51Packages.buildLuarocksPackage {
  pname = "subprocess";
  version = "scm-1";

  src = fetchFromGitHub {
    owner = "0x0ade";
    repo = "lua-subprocess";
    rev = "bfa8e97da774141f301cfd1106dca53a30a4de54";
    sha256 = "sha256-4LiYWB3PAQ/s33Yj/gwC+Ef1vGe5FedWexeCBVSDIV0=";
  };

  meta = {
    homepage = "https://github.com/xlq/lua-subprocess";
    description =
      "A Lua module written in C that allows you to create child processes and communicate with them.";
    license = lib.licenses.mit;
  };
}
