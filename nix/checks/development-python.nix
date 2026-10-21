# Supply shared validator tooling without changing a project's native dependency graph.
{
  pkgs,
  python ? pkgs.python3,
  pythonSet ? null,
  pyproject-nix ? null,
  name ? "repository-development",
  dependencies ? { },
}:
if pythonSet == null then
  python.withPackages (packages: [ packages.pyyaml ])
else
  let
    hacks = pkgs.callPackage pyproject-nix.build.hacks { };
    toolingSet = pythonSet.overrideScope (
      _: prev:
      pkgs.lib.optionalAttrs (!(prev ? pyyaml)) {
        pyyaml = hacks.nixpkgsPrebuilt { from = pythonSet.python.pkgs.pyyaml; };
      }
    );
  in
  toolingSet.mkVirtualEnv name (dependencies // { pyyaml = dependencies.pyyaml or [ ]; })
