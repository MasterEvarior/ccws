# Cool Coding Websites (CCWS)

A curated collection of interesting, tricky, and educational programming websites.

This entire website is a static site generated using **pure Nix**. There are no static site generators (like Hugo or Jekyll) involved, just Nix expression language generating HTML strings, managed via Flakes.

Why Nix? Because I can.

## Prerequisites

To build and develop this project, you need:

1.  **[Nix](https://nixos.org/download.html)** with **Flakes** enabled.
2.  (Optional) **[direnv](https://direnv.net/)** for automatic environment loading.

## Getting Started

### 1. Enter the Environment

If you have `direnv` installed:

```bash
direnv allow
```

Otherwise, manually enter the Nix shell:

```bash
nix develop
```

### 2. Build the site

This will compile the Nix expressions into HTML files and output them to the `./result` directory.

```bash
just build
# OR
nix build
```

After building, you can open `result/index.html` in your browser to view the site.

### 3. Run locally

You can run the project locally with a small Python script and automatic change detection.

```bash
just run
# OR
nix run
```

### 4. Development Commands

This project uses `just` as a command runner. Run `just` to see all available command.

## How to Add a Website

To add a new website, add a new attribute set in `src/content.nix`

```nix
{
  title = "Name of Website";
  link = "https://example.com";
  description = "A brief description of what makes this site cool.";
  tags = [
    "tag1"
    "tag2"
  ];
}
```

## Tech Stack

- Language: Nix
- Templating: Nix String Interpolation (`src/lib/elements.nix`)
- Styling: CSS (src/style.css)
- CI/CD: GitHub Actions (configured in `.github/workflows/quality.yaml`)

## Credits

Credit where credit is due.

- [Emi for this great article](https://garnix.dev/posts/using_nix_as_a_static_site_generator)
- [Patryk Wychowaniec for his great example and `app.py` that I stole](https://codeberg.org/pwy/website/src/branch/main)
