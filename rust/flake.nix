{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } {
    systems = inputs.nixpkgs.lib.systems.flakeExposed;

    perSystem = { pkgs, system, ... }:
      let
        rustFromFile = pkgs.rust-bin.fromRustupToolchainFile ./rust-toolchain.toml;
      in
      {
        _module.args.pkgs = import inputs.nixpkgs {
          inherit system;
          overlays = [ inputs.rust-overlay.overlays.default ];
        };

        formatter = pkgs.nixpkgs-fmt;

        devShells.default = with pkgs; mkShell {
          packages = [
            rustFromFile
          ];

          RUST_SRC_PATH = "${rustFromFile}/lib/rustlib/src/rust";
        };
      };
  };
}
