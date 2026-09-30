{
  description = "Nix Packages repository environment";

  inputs = {
    nixpkgs.url = "https://flakehub.com/f/DeterminateSystems/nixpkgs-weekly/0.1";


  };

  outputs = {
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

      packages = forAllSystems (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};

        in import ./nix/packages {
          inherit lib pkgs;
        });



      devShells = forAllSystems (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};


        in
        {
          default = pkgs.mkShell {
            packages = [



              pkgs.bash
              pkgs.check-jsonschema
              pkgs.jq
              pkgs.nix
              pkgs.shellcheck
              pkgs.worktrunk
              pkgs.yq-go
            ];
            env = {
              AGENT_RUNTIME_REAL_GIT = "${pkgs.git}/bin/git";
              AGENT_RUNTIME_REAL_GH = "${pkgs.gh}/bin/gh";
              WORKTRUNK_WORKTREE_PATH = "~/projects/worktrees/{{ repo }}/{{ branch | sanitize }}";

            };

          };
        });

      checks = forAllSystems (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};


        in import ./nix/checks {

          inherit pkgs;


          source = self;
        });
    };
}
