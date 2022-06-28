use std::env::current_dir;

fn main() {
    println!(
        "cargo:rustc-link-search={}",
        current_dir().unwrap().display()
    );
    println!("cargo:rerun-if-changed=memory.x");
}
