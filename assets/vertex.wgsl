struct Uniforms {
    width: f32,
    height: f32,
    time: f32,
    rand: f32,
    noises: vec4<f32>,
    year: u32,
    month: u32,
    day: u32,
    secs: u32,
}

// the rest was adapted somewhat from Claude
struct VertexOutput {
    @builtin(position) clip_position: vec4<f32>,
    @location(0) coord: vec2<f32>,
    @location(1) resolution: vec2<f32>,
    @location(2) time: f32,
    @location(3) rand: f32,
    @location(4) noises: vec4<f32>,
    @location(5) datetime: vec4<u32>
}

@group(0)
@binding(0)
var<uniform> uniforms: Uniforms;

@vertex
fn vs_main(@builtin(vertex_index) vertex_index: u32) -> VertexOutput {
    var out: VertexOutput;
    let x = f32((vertex_index << 1u) & 2u);
    let y = f32(vertex_index & 2u);
    out.clip_position = vec4<f32>(x * 2. - 1., y * 2. - 1., 0., 1.);
    out.coord = vec2<f32>(x, y);
    out.time = uniforms.time;
    out.resolution = vec2(uniforms.width, uniforms.height);
    out.rand = uniforms.rand;
    out.noises = uniforms.noises;
    out.datetime = vec4<u32>(uniforms.year, uniforms.month, uniforms.day, uniforms.secs);
    return out;
}
