struct FragmentOutput { @location(0) o: vec4<f32>, }

var<private> o: vec4<f32>;
var<private> coord: vec2<f32>;
var<private> RESOLUTION: vec2<f32>;
var<private> TIME: f32;
var<private> RAND: f32;
var<private> NOISE: f32;
var<private> DATETIME: vec4<u32>;
@group(0) @binding(1) var bg_texture: texture_2d<f32>;
@group(0) @binding(2) var bg_sampler: sampler;

const TAU: f32 = 6.2831853;
const PI: f32 = TAU / 2.;

fn rand(input: f32) -> f32 {
    // return fract(sin(input) * 43758.5453);
    var seed = fract(input * 0.1031);
    seed *= seed + 33.33;
    seed *= seed + seed;
    return fract(seed);
}

fn square(n: f32) -> f32 {
    return n * n;
}

fn skycolor(secs: u32) -> vec3<f32> { // thank god for desmos
    if (secs < 28800) {
        let x = f32(secs) / 28800.;
        let r = .3*x + .35;
        let g = .7*x + .15;
        let b = .9 - .8*square(x - 1.);
        var f = x + 0.82574; // x + sqrt(1 / 0.3) - 1, of course
        f *= .3*f;
        return f * vec3(r, g, b);
    } else if (secs < 57600) {
        let x = f32(secs - 28800) / 28880.;
        let r = .65 - .3*x;
        let g = 0.;
        if (x < 0.4) { let g = .898 - .3*square(x - .4); }
        else { let g = .898 - square(x - .4); }
        let b = .1*x + .9;
        return vec3(r, g, b);
    } else if (secs < 72000) {
        let x = f32(secs - 57600) / 14400.;
        let r = min(1., square(5.*x) + .35);
        let g = max(0., .538 - .6*x);
        let b = .2 / (x + .2);
        let f = min(1., 1.2 - x);
        return f * vec3(r, g, b);
    } else {
        let x = f32(secs - 72000) / 14400.;
        let r = 1. - .65*x;
        let g = .15*x;
        var b = 0.;
        if (x < 0.77) { b = 1. - .69*square(2.*x - 1.1); }
        else { b = .91 - square(3.*x - 2.1); }
        let f = .2;
        return f * vec3(r, g, b);
    }
}

// CLOUD FUNCTIONS

fn light(raypos: vec3<f32>, normal: vec3<f32>, lightpos: vec3<f32>) -> f32 {
    let light: vec3<f32> = normalize(lightpos - raypos);
    var dif: f32 = dot(normal, light);
    dif = max(dif, 0.);
    dif *= 0.5;
    dif += 0.5;
    return dif;
}

const CLOUD_DIMENSIONS: vec3<f32> = vec3<f32>(1., 0.25, 1.);

fn intersectPlane(ro: vec3<f32>, rd: vec3<f32>, face: u32) -> vec3<f32> { // face == 0 means x, 1 means y, and 2 means z
    let o = ro[face];
    let d = rd[face];
    return ro - o * rd / d; // thank you ABSOLUTELY NO ONE I FIGURED THIS OUT MYSELF :DDD
}

fn renderCloud(ro: vec3<f32>, rd: vec3<f32>, secs: u32) -> f32 {
    let ros = array<vec3<f32>, 6>(
        ro, ro - vec2(CLOUD_DIMENSIONS.x, 0.).xyy,
        ro, ro - vec2(CLOUD_DIMENSIONS.y, 0.).yxy,
        ro, ro - vec2(CLOUD_DIMENSIONS.z, 0.).yyx
    );
    let order = array<u32,6>(4, 2, 1, 0, 3, 5);
    var i: u32 = 0;
    var intersect = vec3(0.);
    var h = 0;
    for (; h < 6; h++) {
        i = order[h];
        intersect = intersectPlane(ros[i], rd, i / 2);
        if (
            ((i == 0 || i == 1) && intersect.y > 0. && intersect.z > 0. && intersect.y < CLOUD_DIMENSIONS.y && intersect.z < CLOUD_DIMENSIONS.z) ||
            ((i == 2 || i == 3) && intersect.x > 0. && intersect.z > 0. && intersect.x < CLOUD_DIMENSIONS.x && intersect.z < CLOUD_DIMENSIONS.z) ||
            ((i == 4 || i == 5) && intersect.x > 0. && intersect.y > 0. && intersect.x < CLOUD_DIMENSIONS.x && intersect.y < CLOUD_DIMENSIONS.y)
        ) { break; }
    }
    if (h == 6) { return 0.; }

    let normals = array<vec3<f32>, 6>(
        vec3(-1.,  0.,  0.),
        vec3( 1.,  0.,  0.),
        vec3( 0., -1.,  0.),
        vec3( 0.,  1.,  0.),
        vec3( 0.,  0., -1.),
        vec3( 0.,  0.,  1.),
    );
    let normal = normals[i];
    let lighttime = ((f32(secs) / 86400.) * TAU) - PI/2.;
    let lightpos = vec3(
        5. - cos(lighttime) * 3.,
        max(sin(lighttime), 0.) * 5.,
        cos(lighttime) * -10.
    );
    let mainlight = 0.7 * light(intersect, normal, lightpos);
    let ambientlight = 0.3 * light(intersect, normal, vec3(5., 2., -5.));
    let lightfactor = min(sin(lighttime), 0.) * 0.8 + 0.2 + 1.;
    return lightfactor * (mainlight + ambientlight);
}

const CLOUD_CHANCE: f32 = 0.08;

fn renderClouds(uv: vec2<f32>, secs: u32) -> f32 {
    var result: f32 = 0.;

    var rduv: vec2<f32> = uv - 0.8;
    rduv.x *= RESOLUTION.x / RESOLUTION.y;
    rduv *= 0.9;
    let pos = TIME * 0.1 + 15.;
    let rd = normalize(vec3(rduv, 1.));

    for (var z: f32 = -20.; z <= -9.; z += 1.) {
        var offset: u32 = 0;
        var x = pos;
        for (var i: u32 = 0; normalize(vec3(x, -1.2, z)).x > -0.4; i++) {
            let ro = vec3(x, -1.2, z);

            if (normalize(ro).x > 0.9) {
                var delta = floor(x) - z * -2.;
                delta = max(delta, 1.);
                offset += u32(delta);
                x -= delta;
                i--;
                continue;
            }
            x -= 1.;
            if (rand((z * 1.63287 + f32(i + offset)) % sqrt(2.)) > CLOUD_CHANCE) { continue; }
            let cloud = renderCloud(ro, rd, secs);
            if (cloud > 0.) { result = cloud; }
        }
    }
    return result;
}

// GRASS FUNCTIONS

fn grassHeight(x: f32) -> f32 {
    return ((smoothstep(0.2, 1., (1. - x)) * 0.2) + 0.07);
}

const NUMGRASSES: u32 = 200;
const GRASSOFFSETWIDTH: f32 = 0.003; // width of the random offset of grassPos
const GRASSOFFSETHEIGHT: f32 = 0.025; // height of the random offset of grasPos

fn grassPos(i: u32) -> vec2<f32> {
    let x = f32(i)/(f32(NUMGRASSES) + 1.) + rand(f32(i)) * GRASSOFFSETWIDTH;
    return vec2(x, grassHeight(x));
}

const GRASSWIDTH: f32 = 0.0035;
const GRASSHEIGHT: f32 = 0.03;

fn renderGrasses() -> vec4<f32> {
    for (var i: u32 = 0; i <= NUMGRASSES; i++) {
        let grasspos = grassPos(i);
        let offset = 1.5 * square(coord.y - grasspos.y) * NOISE * (rand(f32(i)) * 0.4 + 0.6);
        if (
            coord.x > grasspos.x + offset &&
            coord.x < grasspos.x + offset + GRASSWIDTH &&
            coord.y < grasspos.y + GRASSHEIGHT + rand(f32(i)) * GRASSOFFSETHEIGHT
        ) {
            return vec4(0., 0.5 + rand(f32(i) + 0.1) * 0.05, 0., 1.);
        }
    }
    return vec4(0.);
}

@fragment
fn main(@location(0) _coord: vec2<f32>, @location(1) resolution: vec2<f32>, @location(2) time: f32, @location(3) rand: f32, @location(4) noise: f32, @location(5) @interpolate(flat) datetime: vec4<u32>) -> FragmentOutput {
    coord = _coord;
    RESOLUTION = resolution;
    TIME = time;
    RAND = rand;
    NOISE = noise;
    DATETIME = datetime;

    let secs: u32 = DATETIME.w;
    // let secs = u32(modf(TIME * 5000., 86400.));
    // let secs: u32 = 30000;

    var o = vec4(0.);

    if coord.y > 0.862 {
        let cloud = renderClouds(coord, secs);
        if (cloud > 0.) { o = mix(o, vec4(vec3(cloud), 1.), 0.8); }
    }

    let grassheight = grassHeight(coord.x);
    if coord.y > grassheight && coord.y < grassheight + GRASSHEIGHT + GRASSOFFSETHEIGHT {
        let grass = renderGrasses();
        if grass.a > 0. {
            o = grass;
        }
    }

    let flipcoord = vec2(coord.x, 1. - coord.y); // dont know why this is necessary but it is
    let bg: vec4<f32> = textureSample(bg_texture, bg_sampler, flipcoord);
    o = mix(bg, o, 1. - bg.a);
    // o.a = 1.;

    return FragmentOutput(o);
}
