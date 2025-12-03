{ lib, ccws, ... }:
rec {
  mkSite =
    {
      title,
      lang ? "en",
      charset ? "UTF-8",
      stylesheets ? [ ],
      cards ? [ ],
    }:
    ''
      <!DOCTYPE html>
      <html lang="${lang}">
        <head>
          <meta charset="${charset}" />
          <meta name="viewport" content="width=device-width, initial-scale=1.0" />
          ${mkStylesheetLinks stylesheets}
          <title>${title}</title>
        </head>
      </html>
      <body>
        ${ccws.elements.mkHeader title}
        <main>
         <div class="link-grid">
          ${lib.concatLines (map (c: ccws.elements.mkCard c) cards)}
          </div>
        </main>
        ${ccws.elements.mkFooter}
      </body>
    '';

  mkStylesheetLinks =
    stylesheets: lib.concatLines (map (s: ''<style>${builtins.readFile s}</style>'') stylesheets);

}
