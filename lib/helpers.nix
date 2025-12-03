{ lib }:
{
  mkStylesheetLinks =
    stylesheets: lib.concatLines (map (s: ''<style>${builtins.readFile s}</style>'') stylesheets);
}
