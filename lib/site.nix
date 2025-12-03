{
  pkgs,
  lib,
  ccws,
  ...
}:
rec {

  mkSite2 = pkgs.linkFarm "website" [
    {
      name = "index.html";
      path = pkgs.writeTextFile {
        name = "index.html";
        text = mkIndex {
          title = "CWS - Cool Coding Websites";
          cards = import ./../content.nix;
        };
      };
    }
    {
      name = "quiz.html";
      path = pkgs.writeText "quiz.html" (mkTagPage (import ./../content.nix) "quiz");
    }
  ];

  mkIndex =
    {
      title,
      cards ? [ ],
    }:
    ccws.elements.mkPage {
      title = title;
      content = (lib.concatLines (map (c: ccws.elements.mkCard c) cards));
    };

  mkTagPage =
    cards: tag:
    ccws.elements.mkPage {
      title = "CWS - ${tag}";
      content = lib.concatLines (map (c: ccws.elements.mkCard c) (extractCards cards tag));
    };

  extractCards = cards: tag: (lib.filter (c: lib.elem tag c.tags) cards);

  mkStylesheetLinks =
    stylesheets: lib.concatLines (map (s: ''<style>${builtins.readFile s}</style>'') stylesheets);

}
