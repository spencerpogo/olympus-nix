{
  inputs = {nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";};

  outputs = {
    self,
    nixpkgs,
  }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    sharp = pkgs.callPackage ./sharp.nix {};
    olympus = pkgs.callPackage ./olympus.nix {
      inherit sharp;
      inherit (pkgs.gnome) zenity;
    };
  in {packages.${system} = {inherit sharp olympus;};};
}
