{ pkgs, ... }:

let
  collection =
    pkgs.runCommand "nix-packages-0.1.0"
      {
        src = ../..;
      }
      ''
        mkdir -p "$out/share/nix-packages"
        cp "$src/release-units.json" "$out/share/nix-packages/release-units.json"
        cp "$src/repository-development.json" "$out/share/nix-packages/repository-development.json"
        cp "$src/.idleforge/repository.yaml" "$out/share/nix-packages/repository.yaml"
      '';
in
{
  "nix-packages" = collection;
  default = collection;
}
