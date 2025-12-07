lint system="x86_64-linux":
    @echo "Linting..."
    nix build .#checks.{{system}}.lint

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
