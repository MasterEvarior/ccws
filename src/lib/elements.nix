{ lib, ... }:
rec {

  mkPage =
    {
      title,
      lang ? "en",
      charset ? "UTF-8",
      content ? "",
      tags ? [ ],
      pathToRoot ? ".",
    }:
    ''
      <!DOCTYPE html>
      <html lang="${lang}">
        <head>
          <meta charset="${charset}" />
          <meta name="viewport" content="width=device-width, initial-scale=1.0" />
          ${mkStylesheetLinks [ ../style.css ]}
          <title>${title}</title>
        </head>
      </html>
      <body>
        ${mkHeader title}
        <main>
          ${mkTagBar tags pathToRoot}
         <div class="link-grid">
          ${content}
          </div>
        </main>
        ${mkFooter}
      </body>
    '';

  mkHeader = title: ''
    <header>
      <div class="logo">
        <svg
          width="24"
          height="24"
          viewBox="0 0 24 24"
          fill="none"
          stroke="currentColor"
          stroke-width="2"
          stroke-linecap="round"
          stroke-linejoin="round"
        >
          <path
            d="M10 13a5 5 0 0 0 7.54.54l3-3a5 5 0 0 0-7.07-7.07l-1.72 1.71"
          ></path>
          <path
            d="M14 11a5 5 0 0 0-7.54-.54l-3 3a5 5 0 0 0 7.07 7.07l1.71-1.71"
          ></path>
        </svg>
        ${title}
      </div>
    </header>
  '';

  mkTagBar = tags: rootPath: ''
    <div class="tag-bar">
    ${lib.concatLines (
      [
        (mkTagLink' "all" "../index.html")
      ]
      ++ (map (t: mkTagLink t rootPath) tags)
    )}
    </div>
  '';

  mkFooter = ''
    <footer>
      <a href="https://github.com/MasterEvarior/ccws">Source available here</a>
    </footer>'';

  mkCard =
    {
      title,
      link,
      description,
      tags,
    }:
    ''
      <a href="${link}" class="card">
           <div class="card-header">
             <span class="card-title">${title}</span>
             <div class="card-icon">↗</div>
           </div>
           <div class="card-description">
            ${description}
           </div>
           <div class="card-meta">
             ${lib.concatLines (map mkTag tags)}
           </div>
         </a>
    '';

  mkTagLink = t: p: mkTagLink' t "${p}/tags/${t}.html";

  mkTagLink' = tag: link: ''<span class="tag"><a href="${link}">${lib.toLower tag}</a></span>'';

  mkTag = t: ''<span class="tag" href="tags/${t}.html">${lib.toLower t}</span>'';

  mkStylesheetLinks =
    stylesheets: lib.concatLines (map (s: ''<style>${builtins.readFile s}</style>'') stylesheets);
}
