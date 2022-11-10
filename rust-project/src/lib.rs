pub fn greet() {
    println!("Hello, Rust!");
}

#[cfg(test)]
mod tests {
    #[test]
    fn it_works() {
        assert!(true)
    }
}
