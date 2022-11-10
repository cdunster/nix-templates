{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs = { self, nixpkgs, flake-utils, rust-overlay }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system}.appendOverlays [
          rust-overlay.overlays.default
        ];
        rustFromFile = pkgs.rust-bin.fromRustupToolchainFile ./rust-toolchain.toml;
      in
      {
        devShell = with pkgs; mkShell {
          nativeBuildInputs = [ rustFromFile ];

          buildInputs = [
            cargo-audit
            cargo-edit
          ];

          RUST_SRC_PATH = rustPlatform.rustLibSrc;
        };
      });
}
