#![no_std]
#![no_main]
#![feature(alloc_error_handler)]

use alloc_cortex_m::CortexMHeap;
use core::alloc::Layout;
use core::sync::atomic::{AtomicUsize, Ordering};
use defmt::panic;
use defmt_rtt as _;
use nrf52832_hal as _;
use panic_probe as _;

#[defmt::panic_handler]
fn panic() -> ! {
    cortex_m::asm::udf()
}

#[global_allocator]
static ALLOCATOR: CortexMHeap = CortexMHeap::empty();

#[alloc_error_handler]
fn alloc_error(_layout: Layout) -> ! {
    panic!("Alloc error");
}

defmt::timestamp! {"{=u64}", {
        static COUNT: AtomicUsize = AtomicUsize::new(0);
        let timestamp = COUNT.fetch_add(1, Ordering::Relaxed);
        timestamp as u64
    }
}

#[cfg(test)]
#[defmt_test::tests]
mod unit_tests {
    use defmt::assert;

    #[test]
    fn it_works() {
        assert!(true)
    }
}
