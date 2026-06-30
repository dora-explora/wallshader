use std::{thread::sleep, time::Duration};

use log::info;

mod client;

fn main() {
    env_logger::init();

    let (mut state, mut event_queue) = client::init();

    // We don't draw immediately, the configure will notify us when to first draw.
    loop {
        if event_queue.blocking_dispatch(&mut state).expect("Dispatch error for ") > 0 {
            info!("processed event");
        }

        sleep(Duration::from_millis(100));

        if state.exit {
            println!("exiting example");
            break;
        }
    }

    drop(state.surface);
    drop(state.layer_surface);
    drop(state.layer_shell);
}
