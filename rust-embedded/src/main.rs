#![no_std]
#![no_main]

use defmt::info;
// TODO: Add crate name here.
use {{crate_name}} as _;

#[cortex_m_rt::entry]
fn main() -> ! {
    info!("Hello Embedded Rust!");

    loop {
        cortex_m::asm::bkpt();
    }
}
