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
      rust-iced = {
        path = ./rust-iced;
        description = "A simple template for using iced-rs the Rust GUI framework based on Elm.";
      };
      rust-cursive = {
        path = ./rust-cursive;
        description = "A simple template for using cursive; the Rust TUI framework using ncurses.";
      };
      rust-bevy = {
        path = ./rust-bevy;
        description = "A template for using the Bevy Game Engine.";
      };
    };
  };
}
