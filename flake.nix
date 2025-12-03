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
        ccws =
          (import ./lib/default.nix {
            inherit pkgs;
          }).ccws;
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = [

          ];
          shellHook = "";
        };

        packages.default = pkgs.writeTextFile {
          name = "index.html";
          text = ccws.site.mkSite {
            title = "CWS - Cool Coding Websites";
            stylesheets = [ ./assets/style.css ];
            cards = [
              {
                title = "jsdate.wtf";
                link = "https://jsdate.wtf/";
                description = "";
                tags = [
                  "test"
                  "other"
                ];
              }
              {
                title = "e-mail.wtf";
                link = "https://jsdate.wtf/";
                description = "";
                tags = [ ];
              }
              {
                title = "jsdate.wtf";
                link = "https://jsdate.wtf/";
                description = "";
                tags = [ ];
              }
              {
                title = "jsdate.wtf";
                link = "https://jsdate.wtf/";
                description = "";
                tags = [ ];
              }
            ];
          };
        };
      }
    );
}
