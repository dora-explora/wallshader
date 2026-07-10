struct FragmentOutput {
    @location(0) o: vec4<f32>,
}

const TAU: f32 = 6.2831855f;
const PI: f32 = 3.1415927f;
const CLOUD_DIMENSIONS: vec3<f32> = vec3<f32>(1f, 0.25f, 1f);
const CLOUD_CHANCE: f32 = 0.08f;
const NUMGRASSES: i32 = 200i;
const GRASSOFFSETWIDTH: f32 = 0.003f;
const GRASSOFFSETHEIGHT: f32 = 0.025f;
const GRASSWIDTH: f32 = 0.0035f;
const GRASSHEIGHT: f32 = 0.03f;

var<private> o_1: vec4<f32>;
var<private> coord_1: vec2<f32>;
var<private> RESOLUTION_1: vec2<f32>;
var<private> TIME_1: f32;
var<private> RAND_1: f32;
var<private> NOISE_1: f32;
var<private> DATETIME_1: vec4<u32>;
@group(0) @binding(1) 
var bg_texture: texture_2d<f32>;
@group(0) @binding(2) 
var bg_sampler: sampler;

fn rand(seed: f32) -> f32 {
    var seed_1: f32;

    seed_1 = seed;
    let _e13 = seed_1;
    seed_1 = fract((_e13 * 0.1031f));
    let _e17 = seed_1;
    let _e18 = seed_1;
    seed_1 = (_e17 * (_e18 + 33.33f));
    let _e22 = seed_1;
    let _e23 = seed_1;
    let _e24 = seed_1;
    seed_1 = (_e22 * (_e23 + _e24));
    let _e27 = seed_1;
    return fract(_e27);
}

fn square(n: f32) -> f32 {
    var n_1: f32;

    n_1 = n;
    let _e13 = n_1;
    let _e14 = n_1;
    return (_e13 * _e14);
}

fn skycolor(secs: u32) -> vec3<f32> {
    var secs_1: u32;
    var x: f32;
    var r: f32;
    var g: f32;
    var b: f32;
    var f: f32;
    var x_1: f32;
    var r_1: f32;
    var g_1: f32;
    var b_1: f32;
    var x_2: f32;
    var r_2: f32;
    var g_2: f32;
    var b_2: f32;
    var f_1: f32;
    var x_3: f32;
    var r_3: f32;
    var g_3: f32;
    var b_3: f32;
    var f_2: f32 = 0.2f;

    secs_1 = secs;
    let _e13 = secs_1;
    if (_e13 < 28800u) {
        {
            let _e17 = secs_1;
            x = (f32(_e17) / 28800f);
            let _e23 = x;
            r = ((0.3f * _e23) + 0.35f);
            let _e29 = x;
            g = ((0.7f * _e29) + 0.15f);
            let _e36 = x;
            let _e39 = square((_e36 - 1f));
            b = (0.9f - (0.8f * _e39));
            let _e43 = x;
            f = (_e43 + 0.82574f);
            let _e47 = f;
            let _e49 = f;
            f = (_e47 * (0.3f * _e49));
            let _e52 = f;
            let _e53 = r;
            let _e54 = g;
            let _e55 = b;
            return (_e52 * vec3<f32>(_e53, _e54, _e55));
        }
    } else {
        let _e58 = secs_1;
        if (_e58 < 57600u) {
            {
                let _e62 = secs_1;
                x_1 = (f32((_e62 - 28800u)) / 28880f);
                let _e72 = x_1;
                r_1 = (0.65f - (0.3f * _e72));
                let _e77 = x_1;
                if (_e77 < 0.4f) {
                    {
                        let _e82 = x_1;
                        let _e85 = square((_e82 - 0.4f));
                        g_1 = (0.898f - (0.3f * _e85));
                    }
                } else {
                    {
                        let _e89 = x_1;
                        let _e92 = square((_e89 - 0.4f));
                        g_1 = (0.898f - _e92);
                    }
                }
                let _e95 = x_1;
                b_1 = ((0.1f * _e95) + 0.9f);
                let _e100 = r_1;
                let _e101 = g_1;
                let _e102 = b_1;
                return vec3<f32>(_e100, _e101, _e102);
            }
        } else {
            let _e104 = secs_1;
            if (_e104 < 72000u) {
                {
                    let _e108 = secs_1;
                    x_2 = (f32((_e108 - 57600u)) / 14400f);
                    let _e118 = x_2;
                    let _e120 = square((5f * _e118));
                    r_2 = min(1f, (_e120 + 0.35f));
                    let _e128 = x_2;
                    g_2 = max(0f, (0.538f - (0.6f * _e128)));
                    let _e134 = x_2;
                    b_2 = (0.2f / (_e134 + 0.2f));
                    let _e141 = x_2;
                    f_1 = min(1f, (1.2f - _e141));
                    let _e145 = f_1;
                    let _e146 = r_2;
                    let _e147 = g_2;
                    let _e148 = b_2;
                    return (_e145 * vec3<f32>(_e146, _e147, _e148));
                }
            } else {
                {
                    let _e151 = secs_1;
                    x_3 = (f32((_e151 - 72000u)) / 14400f);
                    let _e161 = x_3;
                    r_3 = (1f - (0.65f * _e161));
                    let _e166 = x_3;
                    g_3 = (0.15f * _e166);
                    let _e170 = x_3;
                    if (_e170 < 0.77f) {
                        {
                            let _e176 = x_3;
                            let _e180 = square(((2f * _e176) - 1.1f));
                            b_3 = (1f - (0.69f * _e180));
                        }
                    } else {
                        {
                            let _e185 = x_3;
                            let _e189 = square(((3f * _e185) - 2.1f));
                            b_3 = (0.91f - _e189);
                        }
                    }
                    let _e193 = f_2;
                    let _e194 = r_3;
                    let _e195 = g_3;
                    let _e196 = b_3;
                    return (_e193 * vec3<f32>(_e194, _e195, _e196));
                }
            }
        }
    }
}

fn light(raypos: vec3<f32>, normal: vec3<f32>, lightpos: vec3<f32>) -> f32 {
    var raypos_1: vec3<f32>;
    var normal_1: vec3<f32>;
    var lightpos_1: vec3<f32>;
    var light_1: vec3<f32>;
    var dif: f32;

    raypos_1 = raypos;
    normal_1 = normal;
    lightpos_1 = lightpos;
    let _e17 = lightpos_1;
    let _e18 = raypos_1;
    light_1 = normalize((_e17 - _e18));
    let _e22 = normal_1;
    let _e23 = light_1;
    dif = dot(_e22, _e23);
    let _e26 = dif;
    dif = max(_e26, 0f);
    let _e29 = dif;
    dif = (_e29 * 0.5f);
    let _e32 = dif;
    dif = (_e32 + 0.5f);
    let _e35 = dif;
    return _e35;
}

fn intersectPlane(ro: vec3<f32>, rd: vec3<f32>, type_43: i32) -> vec3<f32> {
    var ro_1: vec3<f32>;
    var rd_1: vec3<f32>;
    var type_44: i32;
    var os: array<f32, 3>;
    var ds: array<f32, 3>;
    var o: f32;
    var d: f32;

    ro_1 = ro;
    rd_1 = rd;
    type_44 = type_43;
    let _e21 = ro_1;
    os[0i] = _e21.x;
    let _e25 = ro_1;
    os[1i] = _e25.y;
    let _e29 = ro_1;
    os[2i] = _e29.z;
    let _e34 = rd_1;
    ds[0i] = _e34.x;
    let _e38 = rd_1;
    ds[1i] = _e38.y;
    let _e42 = rd_1;
    ds[2i] = _e42.z;
    let _e44 = type_44;
    let _e46 = os[_e44];
    o = _e46;
    let _e48 = type_44;
    let _e50 = ds[_e48];
    d = _e50;
    let _e52 = ro_1;
    let _e53 = o;
    let _e54 = rd_1;
    let _e56 = d;
    return (_e52 - ((_e53 * _e54) / vec3(_e56)));
}

fn renderCloud(ro_2: vec3<f32>, rd_2: vec3<f32>, secs_2: u32) -> vec2<f32> {
    var ro_3: vec3<f32>;
    var rd_3: vec3<f32>;
    var secs_3: u32;
    var ros: array<vec3<f32>, 6>;
    var order: array<i32, 6>;
    var i: i32;
    var delta: f32 = 0f;
    var intersect: vec3<f32> = vec3(0f);
    var h: i32 = 0i;
    var deltay: f32;
    var deltaz: f32;
    var offset: f32;
    var offset_1: f32;
    var deltax: f32;
    var deltay_1: f32;
    var normals: array<vec3<f32>, 6>;
    var normal_2: vec3<f32>;
    var lighttime: f32;
    var lightpos_2: vec3<f32>;
    var mainlight: f32;
    var ambientlight: f32;
    var lightfactor: f32;

    ro_3 = ro_2;
    rd_3 = rd_2;
    secs_3 = secs_2;
    let _e21 = ro_3;
    ros[0i] = _e21;
    let _e24 = ro_3;
    ros[1i] = (_e24 - vec3<f32>(1f, 0f, 0f));
    let _e35 = ro_3;
    ros[2i] = _e35;
    let _e38 = ro_3;
    ros[3i] = (_e38 - vec3<f32>(0f, 0.25f, 0f));
    let _e49 = ro_3;
    ros[4i] = _e49;
    let _e52 = ro_3;
    ros[5i] = (_e52 - vec3<f32>(0f, 0f, 1f));
    order[0i] = 4i;
    order[1i] = 2i;
    order[2i] = 1i;
    order[3i] = 0i;
    order[4i] = 3i;
    order[5i] = 5i;
    loop {
        let _e88 = h;
        if !((_e88 < 6i)) {
            break;
        }
        {
            let _e95 = h;
            let _e97 = order[_e95];
            i = _e97;
            let _e98 = i;
            let _e100 = ros[_e98];
            let _e101 = rd_3;
            let _e102 = i;
            let _e105 = intersectPlane(_e100, _e101, (_e102 / 2i));
            intersect = _e105;
            let _e106 = i;
            let _e109 = i;
            let _e113 = intersect;
            let _e118 = intersect;
            let _e123 = intersect;
            let _e131 = intersect;
            if ((((((_e106 == 0i) || (_e109 == 1i)) && (_e113.y > 0f)) && (_e118.z > 0f)) && (_e123.y < 0.25f)) && (_e131.z < 1f)) {
                {
                    let _e139 = intersect;
                    deltay = abs((_e139.y - 0.25f));
                    let _e148 = intersect;
                    deltaz = abs((_e148.z - 1f));
                    let _e157 = deltay;
                    let _e158 = deltaz;
                    delta = min(_e157, _e158);
                    let _e160 = delta;
                    let _e163 = deltay;
                    let _e164 = deltaz;
                    if ((_e160 < 1f) && (_e163 > _e164)) {
                        {
                            delta = 1f;
                        }
                    }
                    break;
                }
            }
            let _e168 = i;
            let _e171 = i;
            let _e175 = intersect;
            let _e180 = intersect;
            let _e185 = intersect;
            let _e193 = intersect;
            if ((((((_e168 == 2i) || (_e171 == 3i)) && (_e175.x > 0f)) && (_e180.z > 0f)) && (_e185.x < 1f)) && (_e193.z < 1f)) {
                {
                    offset = 0f;
                    let _e203 = ro_3;
                    if (_e203.x < 0f) {
                        {
                            offset = 1f;
                        }
                    }
                    let _e211 = intersect;
                    let _e213 = offset;
                    let _e216 = intersect;
                    delta = min(abs((_e211.x - _e213)), abs((_e216.z - 1f)));
                    break;
                }
            }
            let _e225 = i;
            let _e228 = i;
            let _e232 = intersect;
            let _e237 = intersect;
            let _e242 = intersect;
            let _e250 = intersect;
            if ((((((_e225 == 4i) || (_e228 == 5i)) && (_e232.x > 0f)) && (_e237.y > 0f)) && (_e242.x < 1f)) && (_e250.y < 0.25f)) {
                {
                    offset_1 = 0f;
                    let _e260 = ro_3;
                    if (_e260.x < 0f) {
                        {
                            offset_1 = 1f;
                        }
                    }
                    let _e268 = intersect;
                    let _e270 = offset_1;
                    deltax = abs((_e268.x - _e270));
                    let _e274 = intersect;
                    deltay_1 = abs((_e274.y - 0.25f));
                    let _e283 = deltax;
                    let _e284 = deltay_1;
                    delta = min(_e283, _e284);
                    let _e286 = delta;
                    let _e289 = deltay_1;
                    let _e290 = deltax;
                    if ((_e286 < 1f) && (_e289 > _e290)) {
                        {
                            delta = 1f;
                        }
                    }
                    break;
                }
            }
        }
        continuing {
            let _e92 = h;
            h = (_e92 + 1i);
        }
    }
    let _e294 = delta;
    if (_e294 == 0f) {
        {
            return vec2(0f);
        }
    }
    let _e299 = delta;
    let _e301 = intersect;
    let _e302 = ro_3;
    delta = (_e299 * (50f - distance(_e301, _e302)));
    normals[0i] = vec3<f32>(-1f, 0f, 0f);
    normals[1i] = vec3<f32>(1f, 0f, 0f);
    normals[2i] = vec3<f32>(0f, -1f, 0f);
    normals[3i] = vec3<f32>(0f, 1f, 0f);
    normals[4i] = vec3<f32>(0f, 0f, -1f);
    normals[5i] = vec3<f32>(0f, 0f, 1f);
    let _e346 = i;
    let _e348 = normals[_e346];
    normal_2 = _e348;
    let _e350 = secs_3;
    lighttime = (((f32(_e350) / 86400f) * TAU) - 1.5707964f);
    let _e361 = lighttime;
    let _e366 = lighttime;
    let _e372 = lighttime;
    lightpos_2 = vec3<f32>((5f - (cos(_e361) * 3f)), (max(sin(_e366), 0f) * 5f), (cos(_e372) * -10f));
    let _e380 = intersect;
    let _e381 = normal_2;
    let _e382 = lightpos_2;
    let _e383 = light(_e380, _e381, _e382);
    mainlight = (0.7f * _e383);
    let _e387 = intersect;
    let _e388 = normal_2;
    let _e394 = light(_e387, _e388, vec3<f32>(5f, 2f, -5f));
    ambientlight = (0.3f * _e394);
    let _e397 = lighttime;
    lightfactor = (((min(sin(_e397), 0f) * 0.8f) + 0.2f) + 1f);
    let _e408 = lightfactor;
    let _e409 = mainlight;
    let _e410 = ambientlight;
    let _e413 = delta;
    return vec2<f32>((_e408 * (_e409 + _e410)), min(_e413, 1f));
}

fn renderClouds(uv: vec2<f32>, secs_4: u32) -> vec2<f32> {
    var uv_1: vec2<f32>;
    var secs_5: u32;
    var result: vec2<f32> = vec2(0f);
    var rduv: vec2<f32>;
    var pos: f32;
    var rd_4: vec3<f32>;
    var z: f32 = -20f;
    var offset_2: i32;
    var x_4: f32;
    var i_1: i32;
    var ro_4: vec3<f32>;
    var delta_1: f32;
    var cloud: vec2<f32>;

    uv_1 = uv;
    secs_5 = secs_4;
    let _e20 = uv_1;
    rduv = (_e20 - vec2(0.8f));
    let _e26 = rduv;
    let _e28 = RESOLUTION_1;
    let _e30 = RESOLUTION_1;
    rduv.x = (_e26.x * (_e28.x / _e30.y));
    let _e34 = rduv;
    rduv = (_e34 * 0.9f);
    let _e37 = TIME_1;
    pos = ((_e37 * 0.1f) + 15f);
    let _e43 = rduv;
    rd_4 = normalize(vec3<f32>(_e43.x, _e43.y, 1f));
    loop {
        let _e53 = z;
        if !((_e53 <= -9f)) {
            break;
        }
        {
            offset_2 = 0i;
            let _e63 = pos;
            x_4 = _e63;
            i_1 = 0i;
            loop {
                let _e67 = x_4;
                let _e70 = z;
                if !((normalize(vec3<f32>(_e67, -1.2f, _e70)).x > -0.4f)) {
                    break;
                }
                {
                    let _e81 = x_4;
                    let _e84 = z;
                    ro_4 = vec3<f32>(_e81, -1.2f, _e84);
                    let _e87 = ro_4;
                    if (normalize(_e87).x > 0.9f) {
                        {
                            let _e92 = x_4;
                            let _e94 = z;
                            delta_1 = (floor(_e92) - (_e94 * -2f));
                            let _e100 = delta_1;
                            delta_1 = max(_e100, 1f);
                            let _e103 = offset_2;
                            let _e104 = delta_1;
                            offset_2 = (_e103 + i32(_e104));
                            let _e107 = x_4;
                            let _e108 = delta_1;
                            x_4 = (_e107 - _e108);
                            let _e110 = i_1;
                            i_1 = (_e110 - 1i);
                            continue;
                        }
                    }
                    let _e113 = x_4;
                    x_4 = (_e113 - 1f);
                    let _e116 = z;
                    let _e119 = i_1;
                    let _e120 = offset_2;
                    let _e123 = ((_e116 * 1.63287f) + f32((_e119 + _e120)));
                    let _e130 = rand((_e123 - (floor((_e123 / 1.4142135f)) * 1.4142135f)));
                    if (_e130 > CLOUD_CHANCE) {
                        {
                            continue;
                        }
                    }
                    let _e132 = ro_4;
                    let _e133 = rd_4;
                    let _e134 = secs_5;
                    let _e135 = renderCloud(_e132, _e133, _e134);
                    cloud = _e135;
                    let _e137 = cloud;
                    if (_e137.x > 0f) {
                        {
                            let _e141 = cloud;
                            result = _e141;
                        }
                    }
                }
                continuing {
                    let _e78 = i_1;
                    i_1 = (_e78 + 1i);
                }
            }
        }
        continuing {
            let _e58 = z;
            z = (_e58 + 1f);
        }
    }
    let _e142 = result;
    return _e142;
}

fn grassHeight(x_5: f32) -> f32 {
    var x_6: f32;

    x_6 = x_5;
    let _e18 = x_6;
    return ((smoothstep(0.2f, 1f, (1f - _e18)) * 0.2f) + 0.07f);
}

fn grassPos(i_2: i32) -> vec2<f32> {
    var i_3: i32;
    var x_7: f32;

    i_3 = i_2;
    let _e18 = i_3;
    let _e25 = i_3;
    let _e27 = rand(f32(_e25));
    x_7 = ((f32(_e18) / 201f) + (_e27 * GRASSOFFSETWIDTH));
    let _e31 = x_7;
    let _e32 = x_7;
    let _e33 = grassHeight(_e32);
    return vec2<f32>(_e31, _e33);
}

fn renderGrasses() -> vec4<f32> {
    var i_4: i32 = 0i;
    var grasspos: vec2<f32>;
    var offset_3: f32;

    loop {
        let _e20 = i_4;
        if !((_e20 <= NUMGRASSES)) {
            break;
        }
        {
            let _e26 = i_4;
            let _e27 = grassPos(_e26);
            grasspos = _e27;
            let _e30 = coord_1;
            let _e32 = grasspos;
            let _e35 = square((_e30.y - _e32.y));
            let _e37 = NOISE_1;
            let _e39 = i_4;
            let _e41 = rand(f32(_e39));
            offset_3 = (((1.5f * _e35) * _e37) * ((_e41 * 0.4f) + 0.6f));
            let _e48 = coord_1;
            let _e50 = grasspos;
            let _e52 = offset_3;
            let _e55 = coord_1;
            let _e57 = grasspos;
            let _e59 = offset_3;
            let _e64 = coord_1;
            let _e66 = grasspos;
            let _e69 = i_4;
            let _e71 = rand(f32(_e69));
            if (((_e48.x > (_e50.x + _e52)) && (_e55.x < ((_e57.x + _e59) + GRASSWIDTH))) && (_e64.y < ((_e66.y + GRASSHEIGHT) + (_e71 * GRASSOFFSETHEIGHT)))) {
                {
                    let _e78 = i_4;
                    let _e82 = rand((f32(_e78) + 0.1f));
                    return vec4<f32>(0f, (0.5f + (_e82 * 0.05f)), 0f, 1f);
                }
            }
        }
        continuing {
            let _e23 = i_4;
            i_4 = (_e23 + 1i);
        }
    }
    return vec4(0f);
}

fn main_1() {
    var secs_6: u32;
    var cloud_1: vec2<f32>;
    var grassheight: f32;
    var grass: vec4<f32>;
    var flipcoord: vec2<f32>;

    let _e18 = DATETIME_1;
    secs_6 = _e18.w;
    o_1 = vec4(0f);
    let _e23 = coord_1;
    if (_e23.y > 0.862f) {
        {
            let _e27 = coord_1;
            let _e28 = secs_6;
            let _e29 = renderClouds(_e27, _e28);
            cloud_1 = _e29;
            let _e31 = cloud_1;
            if (_e31.x > 0f) {
                {
                    let _e35 = o_1;
                    let _e36 = cloud_1;
                    let _e37 = _e36.xxx;
                    let _e43 = cloud_1;
                    o_1 = mix(_e35, vec4<f32>(_e37.x, _e37.y, _e37.z, 1f), vec4((_e43.y * 0.8f)));
                }
            }
        }
    }
    let _e49 = coord_1;
    let _e51 = grassHeight(_e49.x);
    grassheight = _e51;
    let _e53 = coord_1;
    let _e55 = grassheight;
    let _e57 = coord_1;
    let _e59 = grassheight;
    if ((_e53.y > _e55) && (_e57.y < ((_e59 + GRASSHEIGHT) + GRASSOFFSETHEIGHT))) {
        {
            let _e64 = renderGrasses();
            grass = _e64;
            let _e66 = grass;
            if (_e66.w > 0f) {
                {
                    let _e70 = grass;
                    o_1 = _e70;
                }
            }
        }
    }
    let _e71 = coord_1;
    let _e74 = coord_1;
    flipcoord = vec2<f32>(_e71.x, (1f - _e74.y));
    let _e79 = flipcoord;
    let _e80 = textureSample(bg_texture, bg_sampler, _e79);
    let _e81 = o_1;
    let _e82 = o_1;
    o_1 = mix(_e80, _e81, vec4(_e82.w));
    o_1.w = 1f;
    return;
}

@fragment 
fn main(@location(0) coord: vec2<f32>, @location(1) RESOLUTION: vec2<f32>, @location(2) TIME: f32, @location(3) RAND: f32, @location(4) NOISE: f32, @location(5) @interpolate(flat) DATETIME: vec4<u32>) -> FragmentOutput {
    coord_1 = coord;
    RESOLUTION_1 = RESOLUTION;
    TIME_1 = TIME;
    RAND_1 = RAND;
    NOISE_1 = NOISE;
    DATETIME_1 = DATETIME;
    main_1();
    let _e49 = o_1;
    return FragmentOutput(_e49);
}
