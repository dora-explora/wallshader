use std::{thread::sleep, time::Duration};

use log::info;
use smithay_client_toolkit::{
    output::OutputState,
    registry::RegistryState,
    seat::SeatState,
    shell::wlr_layer::{LayerShell, LayerSurface},
};
use wgpu::{Adapter, Device, Queue, RenderPipeline, Surface};

mod client;
mod render;

struct State {
    registry_state: RegistryState,
    seat_state: SeatState,
    output_state: OutputState,

    layer_shell: LayerShell,
    layer_surface: LayerSurface,

    exit: bool,
    width: u32,
    height: u32,

    adapter: Adapter,
    device: Device,
    queue: Queue,
    surface: Surface<'static>,
    render_pipeline: RenderPipeline,
}

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
