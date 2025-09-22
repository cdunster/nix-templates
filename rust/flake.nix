{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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

    perSystem = { config, pkgs, system, ... }:
      let
        rustFromFile = pkgs.rust-bin.fromRustupToolchainFile ./rust-toolchain.toml;
      in
      {
        _module.args.pkgs = import inputs.nixpkgs {
          inherit system;
          overlays = [ inputs.rust-overlay.overlays.default ];
        };

        formatter = pkgs.nixpkgs-fmt;

        pre-commit.settings.hooks = {
          # Nix
          nixpkgs-fmt.enable = true;
          deadnix.enable = true;
          statix.enable = true;

          # Rust
          rustfmt.enable = true;

          # Git
          check-merge-conflicts.enable = true;
          no-commit-to-branch.enable = true;
          commitizen.enable = true;

          # TOML
          taplo.enable = true;

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
            rustFromFile
          ];

          RUST_SRC_PATH = "${rustFromFile}/lib/rustlib/src/rust";

          shellHook = "${config.pre-commit.installationScript}";
        };
      };
  };
}
