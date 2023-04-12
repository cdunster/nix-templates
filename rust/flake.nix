{
  inputs = {
    nixpkgs.url = "nixpkgs";
    flake-utils.url = "flake-utils";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs = { self, ... }@inputs:
    inputs.flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = inputs.nixpkgs.legacyPackages.${system}.appendOverlays [
          inputs.rust-overlay.overlays.default
        ];
        rustFromFile = pkgs.rust-bin.fromRustupToolchainFile ./rust-toolchain.toml;
      in
      {
        devShell = with pkgs; mkShell {
          packages = [
            rustFromFile
            cargo-audit
            cargo-edit
            cargo-watch
          ];

          RUST_SRC_PATH = rustPlatform.rustLibSrc;
        };
      });
}
