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
      developmentTools =
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          tools = {
            inherit (pkgs)
              actionlint
              bash
              cacert
              check-jsonschema
              coreutils
              fd
              findutils
              gawk
              gh
              git
              gnugrep
              jq
              lychee
              nix
              nixfmt-rs
              python3
              shellcheck
              statix
              taplo
              worktrunk
              yq-go
              ;
          };
          closure =
            pkgs.linkFarm "nix-packages-development-tools-${builtins.hashFile "sha256" ./flake.lock}"
              (lib.mapAttrsToList (name: path: { inherit name path; }) tools);
        in
        {
          packages = builtins.attrValues tools;
          inherit closure;
        };
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
          development = developmentTools system;
        in
        {
          default = pkgs.mkShell {
            packages = development.packages ++ [ development.closure ];
            env = {
              AGENT_RUNTIME_REAL_GIT = "${pkgs.git}/bin/git";
              AGENT_RUNTIME_REAL_GH = "${pkgs.gh}/bin/gh";
              IDLEFORGE_DEPENDENCY_CLOSURE = "${development.closure}";
              WORKTRUNK_WORKTREE_PATH = "~/projects/worktrees/{{ repo }}/wt-{{ branch | sanitize }}";
            };
          };
        }
      );

      checks = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          development = developmentTools system;
        in
        import ./nix/checks {
          inherit pkgs;
          dependencyClosure = development.closure;
          source = self;
        }
      );
    };
}
