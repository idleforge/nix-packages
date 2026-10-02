{
  pkgs,

  source,
  ...
}:

let
  qualityChecks = {
    nix-format =
      pkgs.runCommand "nix-packages-nix-format"
        {
          nativeBuildInputs = [
            pkgs.bash
            pkgs.fd
            pkgs.nixfmt-rs
          ];
        }
        ''
          bash ${source}/scripts/nixfmt-check ${source}
          touch "$out"
        '';
    nix-lint = pkgs.runCommand "nix-packages-nix-lint" { nativeBuildInputs = [ pkgs.statix ]; } ''
      cd ${source}
      statix check .
      touch "$out"
    '';
  };
in
qualityChecks
// {
  validation =
    pkgs.runCommand "nix-packages-validation"
      {
        nativeBuildInputs = [

          pkgs.bash
          pkgs.check-jsonschema
          pkgs.coreutils
          pkgs.fd
          pkgs.findutils
          pkgs.git
          pkgs.jq
          pkgs.nixfmt-rs
          pkgs.shellcheck
          pkgs.statix
          pkgs.yq-go
          pkgs.actionlint
          pkgs.cacert
          pkgs.lychee
          pkgs.python3
          pkgs.taplo
        ];
        src = source;
        SOURCE_REVISION = source.rev or source.dirtyRev or "uncommitted";
      }
      ''
        cp -R "$src" source
        chmod -R u+w source
        cd source
        export HOME="$TMPDIR/home"
        mkdir -p "$HOME"
        export VALIDATION_RUNNER=direct
        bash ./scripts/validate
        touch "$out"
      '';
}
