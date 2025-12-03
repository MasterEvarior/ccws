{ pkgs, ... }:

rec {
  ccws = {
    site = import ./site.nix {
      inherit (pkgs) lib;
      inherit ccws;
    };
    elements = import ./elements.nix {
      inherit (pkgs) lib;
    };
    helpers = import ./helpers.nix {
      inherit pkgs;
      inherit ccws;
    };
  };
}
