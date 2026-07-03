use std::{thread::sleep, time::{Duration, Instant}};

use encase::ShaderType;
use log::info;
use smithay_client_toolkit::{
    output::OutputState,
    registry::RegistryState,
    seat::SeatState,
    shell::wlr_layer::{LayerShell, LayerSurface},
};
use wgpu::{Adapter, BindGroup, Buffer, Device, Queue, RenderPipeline, Surface};

mod client;
mod render;

#[derive(ShaderType)]
struct Uniforms {
    width: f32,
    height: f32,
    time: f32,
}

impl Uniforms {
    fn as_wgsl_bytes(&self) -> encase::internal::Result<Vec<u8>> { // thank you wgpu shader uniforms example
        let mut buffer = encase::UniformBuffer::new(Vec::new());
        buffer.write(self)?;
        Ok(buffer.into_inner())
    }
}

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
    bind_group: BindGroup,
    render_pipeline: RenderPipeline,

    uniforms: Uniforms,
    uniforms_buffer: Buffer,
}

const FRAMETIME_TARGET: Duration = Duration::from_millis(80);

fn main() {
    env_logger::init();

    let (mut state, mut event_queue) = client::init();

    let start = Instant::now();
    loop {
        let framestart = Instant::now();

        if event_queue.dispatch_pending(&mut state).expect("Dispatch error") > 0 {
            info!("processed event");
        }

        state.uniforms.width = state.width as f32;
        state.uniforms.height = state.height as f32;
        state.uniforms.time = start.elapsed().as_secs_f32();

        state.render().expect("Render error");

        let frametime = framestart.elapsed();
        // println!("frametime: {}ms ({:.0}fps)", frametime.as_micros(), 1. / frametime.as_secs_f32());
        if frametime < FRAMETIME_TARGET {
            sleep(FRAMETIME_TARGET - frametime);
        }

        if state.exit {
            println!("exiting example");
            break;
        }

    }

    drop(state.surface);
    drop(state.layer_surface);
    drop(state.layer_shell);
}
