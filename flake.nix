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
        buildInputs = with pkgs; [
          prettier
          statix
        ];
      in
      {
        devShells.default = pkgs.mkShell {
          inherit buildInputs;

          shellHook = ''
            git config --local core.hooksPath .githooks/
          '';
        };

        packages.default = ccws.site.mkSite;

        checks = {
          lint = pkgs.stdenv.mkDerivation {

            name = "lint";
            src = ./.;
            doCheck = true;

            nativeBuildInputs = buildInputs;

            checkPhase = ''
              ${lib.getExe pkgs.statix} check
            '';

            installPhase = ''
              mkdir "$out"
            '';
          };
        };
      }
    );
}
