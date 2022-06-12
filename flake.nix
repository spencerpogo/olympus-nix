{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs }: let
    system = "x86_64-linux"
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    packages.${system}.olympus = pkgs.callPackage ./olympus.nix {};
  };
}
