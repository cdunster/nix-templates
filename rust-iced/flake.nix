{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
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
        graphicsLibs = with pkgs.xorg; [ pkgs.libglvnd libX11 libXcursor libXrandr libXi ];
      in
      {
        devShell = with pkgs; mkShell {
          nativeBuildInputs = [
            pkgconfig
            fontconfig
            cmake
            graphicsLibs
            rustFromFile
          ];

          packages = [
            cargo-audit
            cargo-edit
          ];

          LD_LIBRARY_PATH = "${lib.makeLibraryPath graphicsLibs}";
        };
      });
}
