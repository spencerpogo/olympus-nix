with import <nixpkgs> {};

lua51Packages.buildLuarocksPackage {
  pname = "lsqlite3complete";
  version = "0.9.5-1";
  #knownRockspec = (fetchurl {
  #  url    = "https://luarocks.org/lsqlite3complete-0.9.5-1.rockspec";
  #  sha256 = "02ain4xf3vmp8kfqyfia292a17h6day778qr39y3z9cana6cd7af";
  #}).outPath;
  src = fetchzip {
    url    = "http://lua.sqlite.org/index.cgi/zip/lsqlite3_fsl09y.zip?uuid=fsl_9y";
    extension = "zip";
    hash = "sha256-lNiYaqZPw31Y8jzW8i7mETtRh9G3/q5EwckJeCg3EL8=";
  };

  propagatedBuildInputs = [ glibc.out ];
  nativeBuildInputs = [ pkg-config ];

  meta = {
    homepage = "http://lua.sqlite.org/";
    description = "A binding for Lua to the SQLite3 database library";
    license.fullName = "MIT";
  };
}
