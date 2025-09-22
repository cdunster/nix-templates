{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } {
    systems = inputs.nixpkgs.lib.systems.flakeExposed;

    perSystem = { pkgs, ... }: {
      formatter = pkgs.nixpkgs-fmt;

      devShells.default = with pkgs; mkShell {
        packages = [
        ];
      };
    };
  };
}
