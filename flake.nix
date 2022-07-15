{
  description = "A collection of Nix flake templates";

  outputs = { self }: {
    templates = {
      rust = {
        path = ./rust;
        description = "A Nix flake template for a Rust project.";
      };
      rust-embedded = {
        path = ./rust-embedded;
        description = "A Nix flake template for a Rust Embedded project.";
      };
    };
  };
}
