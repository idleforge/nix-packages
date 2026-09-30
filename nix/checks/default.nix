
{
  pkgs,

  source,
  ...
}:

{
  validation = pkgs.runCommand "nix-packages-validation"
    {
      nativeBuildInputs = [

        pkgs.bash
        pkgs.check-jsonschema
        pkgs.coreutils
        pkgs.findutils
        pkgs.git
        pkgs.jq
        pkgs.shellcheck
        pkgs.yq-go
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

