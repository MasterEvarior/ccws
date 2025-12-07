{ pkgs, ... }:

rec {
  ccws = {
    site = import ./site.nix {
      inherit pkgs;
      inherit (pkgs) lib;
      inherit ccws;
    };
    elements = import ./elements.nix {
      inherit pkgs;
      inherit (pkgs) lib;
    };
  };
}
