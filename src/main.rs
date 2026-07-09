use std::{thread::sleep, time::{Duration, Instant}};

use chrono::{Datelike, Local, Timelike};
use encase::ShaderType;
use log::info;
use noise::{NoiseFn, Perlin};
use rand::{RngExt, rng};
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
    rand: f32,
    noise: f32,
    year: u32,
    month: u32,
    day: u32,
    secs: u32,
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

const FRAMETIME_TARGET: Duration = Duration::from_millis(120);
const NOISE_SPEED: f64 = 0.8;

fn main() {
    env_logger::init();

    let (mut state, mut event_queue) = client::init();

    let mut rng = rng();
    let perlin = Perlin::new(0);

    let start = Instant::now();
    // let mut frametimes: Vec<u128> =  vec![];
    loop {
        let framestart = Instant::now();

        if event_queue.dispatch_pending(&mut state).expect("Dispatch error") > 0 {
            info!("processed event");
        }

        let datetime = Local::now();

        state.uniforms = Uniforms {
           width: state.width as f32,
           height: state.height as f32,
           time: start.elapsed().as_secs_f32(),
           rand: rng.random(),
           noise: (perlin.get([start.elapsed().as_secs_f64() * NOISE_SPEED]) * 2. - 0.5) as f32,
           year: datetime.year() as u32, // this will be fine assuming christ has been born
           month: datetime.month(),
           day: datetime.day0(),
           secs: datetime.num_seconds_from_midnight(),
        };

        state.render().expect("Render error");

        let frametime = framestart.elapsed();

        // frametimes.push(frametime.as_micros()); // ignore the following long-ass debug println
        // println!("frametime: {}us ({:.0}fps) - avg frametime: {}us", frametime.as_micros(), 1. / frametime.as_secs_f32(), frametimes.iter().sum::<u128>() as usize /frametimes.len());

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
