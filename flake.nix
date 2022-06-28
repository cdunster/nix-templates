{
  description = "A collection of Nix flake templates";

  outputs = { self }: {
    templates = {
      rust-embedded = {
        path = ./rust-embedded;
        description = "A Nix flake template for a Rust Embedded project.";
      };
    };
  };
}
