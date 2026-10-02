{
  description = "Nix Packages repository environment";

  inputs = {
    nixpkgs.url = "https://flakehub.com/f/DeterminateSystems/nixpkgs-weekly/0.1";

  };

  outputs =
    {
      self,

      nixpkgs,

      ...
    }:
    let
      inherit (nixpkgs) lib;
      systems = [ "x86_64-linux" ];
      forAllSystems = lib.genAttrs systems;
    in
    {
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-rs);

      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};

        in
        import ./nix/packages {
          inherit lib pkgs;
        }
      );

      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};

        in
        {
          default = pkgs.mkShell {
            packages = [

              pkgs.bash
              pkgs.actionlint
              pkgs.cacert
              pkgs.git
              pkgs.lychee
              pkgs.python3
              pkgs.taplo
              pkgs.check-jsonschema
              pkgs.fd
              pkgs.jq
              pkgs.nix
              pkgs.nixfmt-rs
              pkgs.shellcheck
              pkgs.statix
              pkgs.worktrunk
              pkgs.yq-go
            ];
            env = {
              AGENT_RUNTIME_REAL_GIT = "${pkgs.git}/bin/git";
              AGENT_RUNTIME_REAL_GH = "${pkgs.gh}/bin/gh";
              WORKTRUNK_WORKTREE_PATH = "~/projects/worktrees/{{ repo }}/{{ branch | sanitize }}";

            };

          };
        }
      );

      checks = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};

        in
        import ./nix/checks {

          inherit pkgs;

          source = self;
        }
      );
    };
}
