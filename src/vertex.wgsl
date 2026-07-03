struct Uniforms {
    width: f32,
    height: f32,
    time: f32,
}

// the rest was adapted somewhat from Claude
struct VertexOutput {
    @builtin(position) clip_position: vec4<f32>,
    @location(0) coord: vec2<f32>,
    @location(1) resolution: vec2<f32>,
    @location(2) time: f32,
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
    return out;
}
