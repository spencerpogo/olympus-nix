{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs }: let
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    packages.x86_64-linux.olympus = pkgs.callPackage ./olympus.nix {};
  };
}
