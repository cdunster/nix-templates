#![no_std]
#![no_main]

// TODO: Add crate name here.
use {{crate_name}} as _;

#[defmt_test::tests]
mod tests {
    use defmt::assert;

    #[test]
    fn it_works() {
        assert!(true)
    }
}
