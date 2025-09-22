{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } {
    systems = inputs.nixpkgs.lib.systems.flakeExposed;

    imports = [
      inputs.git-hooks.flakeModule
    ];

    perSystem = { config, pkgs, ... }: {
      formatter = pkgs.nixpkgs-fmt;

      pre-commit.settings.hooks = {
        # Nix
        nixpkgs-fmt.enable = true;
        deadnix.enable = true;
        statix.enable = true;

        # Git
        check-merge-conflicts.enable = true;
        no-commit-to-branch.enable = true;
        commitizen.enable = true;

        # Spell checking
        typos.enable = true;

        # Whitespace
        mixed-line-endings.enable = true;
        trim-trailing-whitespace.enable = true;

        # Private keys
        detect-private-keys.enable = true;
      };

      devShells.default = with pkgs; mkShell {
        packages = [
          config.pre-commit.settings.enabledPackages
        ];

        shellHook = "${config.pre-commit.installationScript}";
      };
    };
  };
}
