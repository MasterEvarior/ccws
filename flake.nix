{
  description = "A small website with links to other cool coding website";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      ...
    }@inputs:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        inherit (pkgs) lib;
        inherit
          (
            (import ./src/lib/default.nix {
              inherit pkgs;
            })
          )
          ccws
          ;
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            pkgs.just
            pkgs.prettier
            pkgs.nixfmt-tree
            pkgs.statix
          ];

          shellHook = ''
            git config --local core.hooksPath .githooks/
          '';
        };

        packages.default = ccws.site.mkSite;

        checks = {
          lint = pkgs.stdenv.mkDerivation {
            name = "lint";
            src = ./.;

            dontBuild = true;

            doCheck = true;

            checkPhase = ''
              ${lib.getExe pkgs.statix} check
              ${lib.getExe pkgs.prettier} --check .
              ${lib.getExe pkgs.nixfmt-tree} --ci
            '';

            installPhase = ''
              mkdir "$out"
            '';
          };
        };
      }
    );
}
