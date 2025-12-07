{
  pkgs,
  lib,
  ccws,
  ...
}:
rec {
  content = import ./../content.nix;
  uniqueTags = extractAllUniqueTags content;

  mkSite = pkgs.linkFarm "website" [
    {
      name = "index.html";
      path = pkgs.writeText "index.html" (mkIndex {
        title = "CWS - Cool Coding Websites";
        cards = content;
      });
    }
    {
      name = "tags";
      path = pkgs.linkFarm "tags" (mkTagPages content);
    }
  ];

  mkIndex =
    {
      title,
      cards ? [ ],
    }:
    ccws.elements.mkPage {
      inherit title;
      content = lib.concatLines (map (c: ccws.elements.mkCard c) cards);
      tags = uniqueTags;
    };

  mkTagPages =
    cards:
    map (tag: {
      name = "${tag}.html";
      path = mkTagPage cards tag;
    }) (extractAllUniqueTags cards);

  mkTagPage =
    cards: tag:
    pkgs.writeText "${tag}.html" (
      ccws.elements.mkPage {
        title = "CWS - ${tag}";
        content = lib.concatLines (map (c: ccws.elements.mkCard c) (extractContentForTag cards tag));
        tags = uniqueTags;
      }
    );

  extractAllUniqueTags = content: lib.unique (lib.concatMap (x: x.tags) content);
  extractContentForTag = content: tag: (lib.filter (c: lib.elem tag c.tags) content);
}
