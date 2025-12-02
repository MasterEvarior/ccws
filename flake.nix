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
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = [

          ];
          shellHook = "";
        };

        packages.default = pkgs.writeTextFile {
          name = "index.html";
          text = ''
            <!DOCTYPE html>
            <html>
              <head>
                <title>bedroom community</title>
              </head>
              <body>
                <h1>glass beach fan webring</h1>
              </body>
            </html>
          '';
        };
      }
    );
}
