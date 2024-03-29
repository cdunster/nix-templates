use bevy::prelude::*;

fn hello_world() {
    println!("Hello, world!");
}

fn main() {
    App::new()
        .add_plugins(DefaultPlugins)
        .add_system(hello_world)
        .run();
}
