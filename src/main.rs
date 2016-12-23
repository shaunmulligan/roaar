use std::{thread, time};


fn main() {
	let ten_sec = time::Duration::from_millis(10_000);

	while true {

		thread::sleep(ten_sec);
		println!("Hello, world!");
	}
    
}
