struct FragmentOutput {
    @location(0) o: vec4<f32>,
}

const TAU: f32 = 6.2831855f;
const PI: f32 = 3.1415927f;
const CLOUD_DIMENSIONS: vec3<f32> = vec3<f32>(1f, 0.25f, 1f);
const CLOUD_CHANCE: f32 = 0.08f;

var<private> o_1: vec4<f32>;
var<private> coord_1: vec2<f32>;
var<private> RESOLUTION_1: vec2<f32>;
var<private> TIME_1: f32;

fn rand(seed: f32) -> f32 {
    var seed_1: f32;

    seed_1 = seed;
    let _e8 = seed_1;
    seed_1 = fract((_e8 * 0.1031f));
    let _e12 = seed_1;
    let _e13 = seed_1;
    seed_1 = (_e12 * (_e13 + 33.33f));
    let _e17 = seed_1;
    let _e18 = seed_1;
    let _e19 = seed_1;
    seed_1 = (_e17 * (_e18 + _e19));
    let _e22 = seed_1;
    return fract(_e22);
}

fn square(n: f32) -> f32 {
    var n_1: f32;

    n_1 = n;
    let _e8 = n_1;
    let _e9 = n_1;
    return (_e8 * _e9);
}

fn skycolor(secs: i32) -> vec3<f32> {
    var secs_1: i32;
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
    let _e8 = secs_1;
    if (_e8 < 28800i) {
        {
            let _e11 = secs_1;
            x = (f32(_e11) / 28800f);
            let _e17 = x;
            r = ((0.3f * _e17) + 0.35f);
            let _e23 = x;
            g = ((0.7f * _e23) + 0.15f);
            let _e30 = x;
            let _e33 = square((_e30 - 1f));
            b = (0.9f - (0.8f * _e33));
            let _e37 = x;
            f = (_e37 + 0.82574f);
            let _e41 = f;
            let _e43 = f;
            f = (_e41 * (0.3f * _e43));
            let _e46 = f;
            let _e47 = r;
            let _e48 = g;
            let _e49 = b;
            return (_e46 * vec3<f32>(_e47, _e48, _e49));
        }
    } else {
        let _e52 = secs_1;
        if (_e52 < 57600i) {
            {
                let _e55 = secs_1;
                x_1 = (f32((_e55 - 28800i)) / 28880f);
                let _e64 = x_1;
                r_1 = (0.65f - (0.3f * _e64));
                let _e69 = x_1;
                if (_e69 < 0.4f) {
                    {
                        let _e74 = x_1;
                        let _e77 = square((_e74 - 0.4f));
                        g_1 = (0.898f - (0.3f * _e77));
                    }
                } else {
                    {
                        let _e81 = x_1;
                        let _e84 = square((_e81 - 0.4f));
                        g_1 = (0.898f - _e84);
                    }
                }
                let _e87 = x_1;
                b_1 = ((0.1f * _e87) + 0.9f);
                let _e92 = r_1;
                let _e93 = g_1;
                let _e94 = b_1;
                return vec3<f32>(_e92, _e93, _e94);
            }
        } else {
            let _e96 = secs_1;
            if (_e96 < 72000i) {
                {
                    let _e99 = secs_1;
                    x_2 = (f32((_e99 - 57600i)) / 14400f);
                    let _e108 = x_2;
                    let _e110 = square((5f * _e108));
                    r_2 = min(1f, (_e110 + 0.35f));
                    let _e118 = x_2;
                    g_2 = max(0f, (0.538f - (0.6f * _e118)));
                    let _e124 = x_2;
                    b_2 = (0.2f / (_e124 + 0.2f));
                    let _e131 = x_2;
                    f_1 = min(1f, (1.2f - _e131));
                    let _e135 = f_1;
                    let _e136 = r_2;
                    let _e137 = g_2;
                    let _e138 = b_2;
                    return (_e135 * vec3<f32>(_e136, _e137, _e138));
                }
            } else {
                {
                    let _e141 = secs_1;
                    x_3 = (f32((_e141 - 72000i)) / 14400f);
                    let _e150 = x_3;
                    r_3 = (1f - (0.65f * _e150));
                    let _e155 = x_3;
                    g_3 = (0.15f * _e155);
                    let _e159 = x_3;
                    if (_e159 < 0.77f) {
                        {
                            let _e165 = x_3;
                            let _e169 = square(((2f * _e165) - 1.1f));
                            b_3 = (1f - (0.69f * _e169));
                        }
                    } else {
                        {
                            let _e174 = x_3;
                            let _e178 = square(((3f * _e174) - 2.1f));
                            b_3 = (0.91f - _e178);
                        }
                    }
                    let _e182 = f_2;
                    let _e183 = r_3;
                    let _e184 = g_3;
                    let _e185 = b_3;
                    return (_e182 * vec3<f32>(_e183, _e184, _e185));
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
    let _e12 = lightpos_1;
    let _e13 = raypos_1;
    light_1 = normalize((_e12 - _e13));
    let _e17 = normal_1;
    let _e18 = light_1;
    dif = dot(_e17, _e18);
    let _e21 = dif;
    dif = max(_e21, 0f);
    let _e24 = dif;
    dif = (_e24 * 0.5f);
    let _e27 = dif;
    dif = (_e27 + 0.5f);
    let _e30 = dif;
    return _e30;
}

fn intersectPlane(ro: vec3<f32>, rd: vec3<f32>, type_19: i32) -> vec3<f32> {
    var ro_1: vec3<f32>;
    var rd_1: vec3<f32>;
    var type_20: i32;
    var os: array<f32, 3>;
    var ds: array<f32, 3>;
    var o: f32;
    var d: f32;

    ro_1 = ro;
    rd_1 = rd;
    type_20 = type_19;
    let _e16 = ro_1;
    os[0i] = _e16.x;
    let _e20 = ro_1;
    os[1i] = _e20.y;
    let _e24 = ro_1;
    os[2i] = _e24.z;
    let _e29 = rd_1;
    ds[0i] = _e29.x;
    let _e33 = rd_1;
    ds[1i] = _e33.y;
    let _e37 = rd_1;
    ds[2i] = _e37.z;
    let _e39 = type_20;
    let _e41 = os[_e39];
    o = _e41;
    let _e43 = type_20;
    let _e45 = ds[_e43];
    d = _e45;
    let _e47 = ro_1;
    let _e48 = o;
    let _e49 = rd_1;
    let _e51 = d;
    return (_e47 - ((_e48 * _e49) / vec3(_e51)));
}

fn renderCloud(ro_2: vec3<f32>, rd_2: vec3<f32>, secs_2: i32) -> vec2<f32> {
    var ro_3: vec3<f32>;
    var rd_3: vec3<f32>;
    var secs_3: i32;
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
    let _e16 = ro_3;
    ros[0i] = _e16;
    let _e19 = ro_3;
    ros[1i] = (_e19 - vec3<f32>(1f, 0f, 0f));
    let _e30 = ro_3;
    ros[2i] = _e30;
    let _e33 = ro_3;
    ros[3i] = (_e33 - vec3<f32>(0f, 0.25f, 0f));
    let _e44 = ro_3;
    ros[4i] = _e44;
    let _e47 = ro_3;
    ros[5i] = (_e47 - vec3<f32>(0f, 0f, 1f));
    order[0i] = 4i;
    order[1i] = 2i;
    order[2i] = 1i;
    order[3i] = 0i;
    order[4i] = 3i;
    order[5i] = 5i;
    loop {
        let _e83 = h;
        if !((_e83 < 6i)) {
            break;
        }
        {
            let _e90 = h;
            let _e92 = order[_e90];
            i = _e92;
            let _e93 = i;
            let _e95 = ros[_e93];
            let _e96 = rd_3;
            let _e97 = i;
            let _e100 = intersectPlane(_e95, _e96, (_e97 / 2i));
            intersect = _e100;
            let _e101 = i;
            let _e104 = i;
            let _e108 = intersect;
            let _e113 = intersect;
            let _e118 = intersect;
            let _e126 = intersect;
            if ((((((_e101 == 0i) || (_e104 == 1i)) && (_e108.y > 0f)) && (_e113.z > 0f)) && (_e118.y < 0.25f)) && (_e126.z < 1f)) {
                {
                    let _e134 = intersect;
                    deltay = abs((_e134.y - 0.25f));
                    let _e143 = intersect;
                    deltaz = abs((_e143.z - 1f));
                    let _e152 = deltay;
                    let _e153 = deltaz;
                    delta = min(_e152, _e153);
                    let _e155 = delta;
                    let _e158 = deltay;
                    let _e159 = deltaz;
                    if ((_e155 < 1f) && (_e158 > _e159)) {
                        {
                            delta = 1f;
                        }
                    }
                    break;
                }
            }
            let _e163 = i;
            let _e166 = i;
            let _e170 = intersect;
            let _e175 = intersect;
            let _e180 = intersect;
            let _e188 = intersect;
            if ((((((_e163 == 2i) || (_e166 == 3i)) && (_e170.x > 0f)) && (_e175.z > 0f)) && (_e180.x < 1f)) && (_e188.z < 1f)) {
                {
                    offset = 0f;
                    let _e198 = ro_3;
                    if (_e198.x < 0f) {
                        {
                            offset = 1f;
                        }
                    }
                    let _e206 = intersect;
                    let _e208 = offset;
                    let _e211 = intersect;
                    delta = min(abs((_e206.x - _e208)), abs((_e211.z - 1f)));
                    break;
                }
            }
            let _e220 = i;
            let _e223 = i;
            let _e227 = intersect;
            let _e232 = intersect;
            let _e237 = intersect;
            let _e245 = intersect;
            if ((((((_e220 == 4i) || (_e223 == 5i)) && (_e227.x > 0f)) && (_e232.y > 0f)) && (_e237.x < 1f)) && (_e245.y < 0.25f)) {
                {
                    offset_1 = 0f;
                    let _e255 = ro_3;
                    if (_e255.x < 0f) {
                        {
                            offset_1 = 1f;
                        }
                    }
                    let _e263 = intersect;
                    let _e265 = offset_1;
                    deltax = abs((_e263.x - _e265));
                    let _e269 = intersect;
                    deltay_1 = abs((_e269.y - 0.25f));
                    let _e278 = deltax;
                    let _e279 = deltay_1;
                    delta = min(_e278, _e279);
                    let _e281 = delta;
                    let _e284 = deltay_1;
                    let _e285 = deltax;
                    if ((_e281 < 1f) && (_e284 > _e285)) {
                        {
                            delta = 1f;
                        }
                    }
                    break;
                }
            }
        }
        continuing {
            let _e87 = h;
            h = (_e87 + 1i);
        }
    }
    let _e289 = delta;
    if (_e289 == 0f) {
        {
            return vec2(0f);
        }
    }
    let _e294 = delta;
    let _e296 = intersect;
    let _e297 = ro_3;
    delta = (_e294 * (50f - distance(_e296, _e297)));
    normals[0i] = vec3<f32>(-1f, 0f, 0f);
    normals[1i] = vec3<f32>(1f, 0f, 0f);
    normals[2i] = vec3<f32>(0f, -1f, 0f);
    normals[3i] = vec3<f32>(0f, 1f, 0f);
    normals[4i] = vec3<f32>(0f, 0f, -1f);
    normals[5i] = vec3<f32>(0f, 0f, 1f);
    let _e341 = i;
    let _e343 = normals[_e341];
    normal_2 = _e343;
    let _e345 = secs_3;
    lighttime = (((f32(_e345) / 86400f) * TAU) - 1.5707964f);
    let _e356 = lighttime;
    let _e361 = lighttime;
    let _e367 = lighttime;
    lightpos_2 = vec3<f32>((5f - (cos(_e356) * 3f)), (max(sin(_e361), 0f) * 5f), (cos(_e367) * -10f));
    let _e375 = intersect;
    let _e376 = normal_2;
    let _e377 = lightpos_2;
    let _e378 = light(_e375, _e376, _e377);
    mainlight = (0.7f * _e378);
    let _e382 = intersect;
    let _e383 = normal_2;
    let _e389 = light(_e382, _e383, vec3<f32>(5f, 2f, -5f));
    ambientlight = (0.3f * _e389);
    let _e392 = lighttime;
    lightfactor = (((min(sin(_e392), 0f) * 0.8f) + 0.2f) + 1f);
    let _e403 = lightfactor;
    let _e404 = mainlight;
    let _e405 = ambientlight;
    let _e408 = delta;
    return vec2<f32>((_e403 * (_e404 + _e405)), min(_e408, 1f));
}

fn renderClouds(uv: vec2<f32>, secs_4: i32) -> vec2<f32> {
    var uv_1: vec2<f32>;
    var secs_5: i32;
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
    let _e15 = uv_1;
    rduv = (_e15 - vec2(0.8f));
    let _e21 = rduv;
    let _e23 = RESOLUTION_1;
    let _e25 = RESOLUTION_1;
    rduv.x = (_e21.x * (_e23.x / _e25.y));
    let _e29 = rduv;
    rduv = (_e29 * 0.9f);
    let _e32 = TIME_1;
    pos = ((_e32 * 0.1f) + 15f);
    let _e38 = rduv;
    rd_4 = normalize(vec3<f32>(_e38.x, _e38.y, 1f));
    loop {
        let _e48 = z;
        if !((_e48 <= -9f)) {
            break;
        }
        {
            offset_2 = 0i;
            let _e58 = pos;
            x_4 = _e58;
            i_1 = 0i;
            loop {
                let _e62 = x_4;
                let _e65 = z;
                if !((normalize(vec3<f32>(_e62, -1.2f, _e65)).x > -0.4f)) {
                    break;
                }
                {
                    let _e76 = x_4;
                    let _e79 = z;
                    ro_4 = vec3<f32>(_e76, -1.2f, _e79);
                    let _e82 = ro_4;
                    if (normalize(_e82).x > 0.9f) {
                        {
                            let _e87 = x_4;
                            let _e89 = z;
                            delta_1 = (floor(_e87) - (_e89 * -2f));
                            let _e95 = delta_1;
                            delta_1 = max(_e95, 1f);
                            let _e98 = offset_2;
                            let _e99 = delta_1;
                            offset_2 = (_e98 + i32(_e99));
                            let _e102 = x_4;
                            let _e103 = delta_1;
                            x_4 = (_e102 - _e103);
                            let _e105 = i_1;
                            i_1 = (_e105 - 1i);
                            continue;
                        }
                    }
                    let _e108 = x_4;
                    x_4 = (_e108 - 1f);
                    let _e111 = z;
                    let _e114 = i_1;
                    let _e115 = offset_2;
                    let _e118 = ((_e111 * 1.63287f) + f32((_e114 + _e115)));
                    let _e125 = rand((_e118 - (floor((_e118 / 1.4142135f)) * 1.4142135f)));
                    if (_e125 > CLOUD_CHANCE) {
                        {
                            continue;
                        }
                    }
                    let _e127 = ro_4;
                    let _e128 = rd_4;
                    let _e129 = secs_5;
                    let _e130 = renderCloud(_e127, _e128, _e129);
                    cloud = _e130;
                    let _e132 = cloud;
                    if (_e132.x > 0f) {
                        {
                            let _e136 = cloud;
                            result = _e136;
                        }
                    }
                }
                continuing {
                    let _e73 = i_1;
                    i_1 = (_e73 + 1i);
                }
            }
        }
        continuing {
            let _e53 = z;
            z = (_e53 + 1f);
        }
    }
    let _e137 = result;
    return _e137;
}

fn main_1() {
    var pos_1: vec2<f32>;
    var ipos: vec2<i32>;
    var secs_6: i32;
    var cloud_1: vec2<f32>;

    let _e8 = coord_1;
    pos_1 = _e8;
    let _e10 = coord_1;
    ipos = vec2<i32>(_e10);
    let _e13 = TIME_1;
    let _e15 = (_e13 * 5000f);
    secs_6 = i32((_e15 - (floor((_e15 / 86400f)) * 86400f)));
    o_1 = vec4(0f);
    let _e25 = pos_1;
    if (_e25.y > 0.85f) {
        {
            let _e29 = pos_1;
            let _e30 = secs_6;
            let _e31 = renderClouds(_e29, _e30);
            cloud_1 = _e31;
            let _e33 = cloud_1;
            if (_e33.x > 0f) {
                {
                    let _e37 = o_1;
                    let _e38 = cloud_1;
                    let _e39 = _e38.xxx;
                    let _e45 = cloud_1;
                    o_1 = mix(_e37, vec4<f32>(_e39.x, _e39.y, _e39.z, 1f), vec4((_e45.y * 0.8f)));
                    return;
                }
            } else {
                return;
            }
        }
    } else {
        return;
    }
}

@fragment 
fn main(@location(0) coord: vec2<f32>, @location(1) RESOLUTION: vec2<f32>, @location(2) TIME: f32) -> FragmentOutput {
    coord_1 = coord;
    RESOLUTION_1 = RESOLUTION;
    TIME_1 = TIME;
    main_1();
    let _e23 = o_1;
    return FragmentOutput(_e23);
}
