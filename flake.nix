{
  description = "A collection of Nix flake templates";

  outputs = { self }: {
    templates = {
      default = self.templates.boilerplate;
      boilerplate = {
        path = ./boilerplate;
        description = "A template with just the boilerplate for using Nix flakes.";
      };
      rust = {
        path = ./rust;
        description = "A simple template for using Rust.";
      };
      rust-project = {
        path = ./rust-project;
        description = "A template for building and running a Rust project with Nix.";
      };
      rust-embedded = {
        path = ./rust-embedded;
        description = "A template for an Embedded Rust project.";
      };
    };
  };
}
