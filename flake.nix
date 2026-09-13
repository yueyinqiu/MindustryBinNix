{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    { nixpkgs, ... }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      buildPackages =
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          packageFiles = builtins.attrNames (builtins.readDir ./packages);
        in
        pkgs.lib.listToAttrs (
          map (fileName: {
            name = pkgs.lib.removeSuffix ".nix" fileName;
            value = pkgs.callPackage ./packages/${fileName} { };
          }) packageFiles
        );
    in
    {
      packages = nixpkgs.lib.genAttrs systems buildPackages;
    };
}
