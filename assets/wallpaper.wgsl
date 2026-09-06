var<private> coord: vec2<f32>;
var<private> RESOLUTION: vec2<f32>;
var<private> TIME: f32;
var<private> RAND: f32;
var<private> NOISES: vec4<f32>;
var<private> DATETIME: vec4<u32>;

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
const GRASSOFFSETWIDTH: f32 = 0.002; // max width of the random offset of grassPos
const GRASSOFFSETHEIGHT: f32 = 0.04; // max height of the random offset of grasPos

fn grassPos(i: u32) -> vec2<f32> {
    let x = f32(i)/(f32(NUMGRASSES) + 1.) + rand(f32(i)) * GRASSOFFSETWIDTH;
    return vec2(x, grassHeight(x));
}

const GRASSWIDTH: f32 = 0.0035;
const GRASSHEIGHT: f32 = 0.03;

fn renderGrasses() -> vec4<f32> {
    for (var i: u32 = 0; i <= NUMGRASSES; i++) {
        let grasspos = grassPos(i);
        let wind = .3*NOISES[u32(rand(f32(i)) * 3.)] + NOISES[3];
        let offset = 1.5 * square(coord.y - grasspos.y) * wind * (rand(f32(i) + 1.) * 0.4 + 0.6);
        if (
            coord.x > grasspos.x + offset &&
            coord.x < grasspos.x + offset + GRASSWIDTH &&
            coord.y < grasspos.y + GRASSHEIGHT + rand(f32(i) + 2.) * GRASSOFFSETHEIGHT
        ) {
            return vec4(0., 0.6 + rand(f32(i) + 3.) * 0.1, 0.1, 1.);
        }
    }
    return vec4(0.);
}

@fragment
fn main(
    @location(0) _coord: vec2<f32>,
    @location(1) resolution: vec2<f32>,
    @location(2) time: f32,
    @location(3) rand: f32,
    @location(4) noises: vec4<f32>,
    @location(5) @interpolate(flat) datetime: vec4<u32>
)-> @location(0) vec4<f32> {
    coord = _coord;
    RESOLUTION = resolution;
    TIME = time;
    RAND = rand;
    NOISES = noises;
    DATETIME = datetime;

    var o: vec4<f32> = vec4(0.);

    let secs: u32 = DATETIME.w;
    // let secs = u32(TIME * 5000. % 86400.);
    // let secs: u32 = 30000;

    if coord.y > 0.862 {
        let cloud = renderClouds(coord, secs);
        if (cloud > 0.) { o = mix(o, vec4(vec3(cloud), 1.), 0.8); return o; }
    }

    let grassheight = grassHeight(coord.x);
    if coord.y > grassheight && coord.y < grassheight + GRASSHEIGHT + GRASSOFFSETHEIGHT {
        let grass = renderGrasses();
        if grass.a > 0. {
            o = grass;
            return o;
        }
    }

    if coord.y < grassheight {
        o = vec4(0.1, 0.6, 0.05, 1.);
    } else {
        o = vec4(0.2, 0.5, 1., 1.);
    }
    return o;
}
