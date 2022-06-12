{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = { nixpkgs }: {
    packages.x86_64-linux.olympus = nixpkgs.callPackage ./olympus.nix {};
  };
}
