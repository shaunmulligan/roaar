use std::{thread, time};
use std::env;

fn main() {
	let ten_sec = time::Duration::from_millis(10_000);
	let key = "FOO";

	while true {

		match env::var(key) {
		    Ok(val) => println!("{}: {:?}", key, val),
		    Err(e) => println!("couldn't interpret {}: {}", key, e),
		}
		thread::sleep(ten_sec);
		println!("Hello, world!");
	}
    
}
