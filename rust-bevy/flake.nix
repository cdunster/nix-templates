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
        buildtimeLibs = with pkgs; [ pkg-config libudev-zero alsa-lib ];
        runtimeLibs = with pkgs; [ xorg.libX11 xorg.libXcursor xorg.libXrandr xorg.libXi libglvnd ];
      in
      {
        devShell = with pkgs; mkShell {
          packages = buildtimeLibs ++ [
            rustFromFile
          ];

          LD_LIBRARY_PATH = "${lib.makeLibraryPath runtimeLibs}";
        };
      });
}
