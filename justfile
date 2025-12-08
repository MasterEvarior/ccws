alias b := build
alias l := lint
alias u := update
alias uc := update-commit

default:
  @just --list

lint system="x86_64-linux":
    @echo "Linting..."
    nix build .#checks.{{system}}.lint

format:
    prettier --write .
    treefmt
    statix fix .

build:
    @echo "Building the application..."
    nix build

update:
    @echo "Updating flake.nix and flake.lock..."
    nix flake update

update-commit: update
    @echo "Commiting flake.nix and flake.lock..."
    git reset
    git add flake.nix flake.lock
    git commit -m "chore(deps): update flake.nix"