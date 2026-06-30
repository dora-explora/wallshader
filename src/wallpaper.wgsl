struct FragmentOutput {
    @location(0) o: vec4<f32>,
}

const TAU: f32 = 6.2831855f;
const PI: f32 = 3.1415927f;
const CLOUD_DIMENSIONS: vec3<f32> = vec3<f32>(1f, 0.25f, 1f);
const CLOUD_CHANCE: f32 = 0.08f;

var<private> iResolution: vec2<f32> = vec2<f32>(1920f, 1200f);
var<private> o_1: vec4<f32>;
var<private> coord_1: vec2<f32>;

fn rand(seed: f32) -> f32 {
    var seed_1: f32;

    seed_1 = seed;
    let _e5 = seed_1;
    seed_1 = fract((_e5 * 0.1031f));
    let _e9 = seed_1;
    let _e10 = seed_1;
    seed_1 = (_e9 * (_e10 + 33.33f));
    let _e14 = seed_1;
    let _e15 = seed_1;
    let _e16 = seed_1;
    seed_1 = (_e14 * (_e15 + _e16));
    let _e19 = seed_1;
    return fract(_e19);
}

fn square(n: f32) -> f32 {
    var n_1: f32;

    n_1 = n;
    let _e5 = n_1;
    let _e6 = n_1;
    return (_e5 * _e6);
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
    let _e5 = secs_1;
    if (_e5 < 28800i) {
        {
            let _e8 = secs_1;
            x = (f32(_e8) / 28800f);
            let _e14 = x;
            r = ((0.3f * _e14) + 0.35f);
            let _e20 = x;
            g = ((0.7f * _e20) + 0.15f);
            let _e27 = x;
            let _e30 = square((_e27 - 1f));
            b = (0.9f - (0.8f * _e30));
            let _e34 = x;
            f = (_e34 + 0.82574f);
            let _e38 = f;
            let _e40 = f;
            f = (_e38 * (0.3f * _e40));
            let _e43 = f;
            let _e44 = r;
            let _e45 = g;
            let _e46 = b;
            return (_e43 * vec3<f32>(_e44, _e45, _e46));
        }
    } else {
        let _e49 = secs_1;
        if (_e49 < 57600i) {
            {
                let _e52 = secs_1;
                x_1 = (f32((_e52 - 28800i)) / 28880f);
                let _e61 = x_1;
                r_1 = (0.65f - (0.3f * _e61));
                let _e66 = x_1;
                if (_e66 < 0.4f) {
                    {
                        let _e71 = x_1;
                        let _e74 = square((_e71 - 0.4f));
                        g_1 = (0.898f - (0.3f * _e74));
                    }
                } else {
                    {
                        let _e78 = x_1;
                        let _e81 = square((_e78 - 0.4f));
                        g_1 = (0.898f - _e81);
                    }
                }
                let _e84 = x_1;
                b_1 = ((0.1f * _e84) + 0.9f);
                let _e89 = r_1;
                let _e90 = g_1;
                let _e91 = b_1;
                return vec3<f32>(_e89, _e90, _e91);
            }
        } else {
            let _e93 = secs_1;
            if (_e93 < 72000i) {
                {
                    let _e96 = secs_1;
                    x_2 = (f32((_e96 - 57600i)) / 14400f);
                    let _e105 = x_2;
                    let _e107 = square((5f * _e105));
                    r_2 = min(1f, (_e107 + 0.35f));
                    let _e115 = x_2;
                    g_2 = max(0f, (0.538f - (0.6f * _e115)));
                    let _e121 = x_2;
                    b_2 = (0.2f / (_e121 + 0.2f));
                    let _e128 = x_2;
                    f_1 = min(1f, (1.2f - _e128));
                    let _e132 = f_1;
                    let _e133 = r_2;
                    let _e134 = g_2;
                    let _e135 = b_2;
                    return (_e132 * vec3<f32>(_e133, _e134, _e135));
                }
            } else {
                {
                    let _e138 = secs_1;
                    x_3 = (f32((_e138 - 72000i)) / 14400f);
                    let _e147 = x_3;
                    r_3 = (1f - (0.65f * _e147));
                    let _e152 = x_3;
                    g_3 = (0.15f * _e152);
                    let _e156 = x_3;
                    if (_e156 < 0.77f) {
                        {
                            let _e162 = x_3;
                            let _e166 = square(((2f * _e162) - 1.1f));
                            b_3 = (1f - (0.69f * _e166));
                        }
                    } else {
                        {
                            let _e171 = x_3;
                            let _e175 = square(((3f * _e171) - 2.1f));
                            b_3 = (0.91f - _e175);
                        }
                    }
                    let _e179 = f_2;
                    let _e180 = r_3;
                    let _e181 = g_3;
                    let _e182 = b_3;
                    return (_e179 * vec3<f32>(_e180, _e181, _e182));
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
    let _e9 = lightpos_1;
    let _e10 = raypos_1;
    light_1 = normalize((_e9 - _e10));
    let _e14 = normal_1;
    let _e15 = light_1;
    dif = dot(_e14, _e15);
    let _e18 = dif;
    dif = max(_e18, 0f);
    let _e21 = dif;
    dif = (_e21 * 0.5f);
    let _e24 = dif;
    dif = (_e24 + 0.5f);
    let _e27 = dif;
    return _e27;
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
    let _e13 = ro_1;
    os[0i] = _e13.x;
    let _e17 = ro_1;
    os[1i] = _e17.y;
    let _e21 = ro_1;
    os[2i] = _e21.z;
    let _e26 = rd_1;
    ds[0i] = _e26.x;
    let _e30 = rd_1;
    ds[1i] = _e30.y;
    let _e34 = rd_1;
    ds[2i] = _e34.z;
    let _e36 = type_20;
    let _e38 = os[_e36];
    o = _e38;
    let _e40 = type_20;
    let _e42 = ds[_e40];
    d = _e42;
    let _e44 = ro_1;
    let _e45 = o;
    let _e46 = rd_1;
    let _e48 = d;
    return (_e44 - ((_e45 * _e46) / vec3(_e48)));
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
    var offset: f32;
    var offset_1: f32;
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
    let _e13 = ro_3;
    ros[0i] = _e13;
    let _e16 = ro_3;
    ros[1i] = (_e16 - vec3<f32>(1f, 0f, 0f));
    let _e27 = ro_3;
    ros[2i] = _e27;
    let _e30 = ro_3;
    ros[3i] = (_e30 - vec3<f32>(0f, 0.25f, 0f));
    let _e41 = ro_3;
    ros[4i] = _e41;
    let _e44 = ro_3;
    ros[5i] = (_e44 - vec3<f32>(0f, 0f, 1f));
    order[0i] = 4i;
    order[1i] = 2i;
    order[2i] = 1i;
    order[3i] = 0i;
    order[4i] = 3i;
    order[5i] = 5i;
    loop {
        let _e80 = h;
        if !((_e80 < 6i)) {
            break;
        }
        {
            let _e87 = h;
            let _e89 = order[_e87];
            i = _e89;
            let _e90 = i;
            let _e92 = ros[_e90];
            let _e93 = rd_3;
            let _e94 = i;
            let _e97 = intersectPlane(_e92, _e93, (_e94 / 2i));
            intersect = _e97;
            let _e98 = i;
            let _e101 = i;
            let _e105 = intersect;
            let _e110 = intersect;
            let _e115 = intersect;
            let _e123 = intersect;
            if ((((((_e98 == 0i) || (_e101 == 1i)) && (_e105.y > 0f)) && (_e110.z > 0f)) && (_e115.y < 0.25f)) && (_e123.z < 1f)) {
                {
                    let _e131 = intersect;
                    let _e139 = intersect;
                    delta = min(abs((_e131.y - 0.25f)), abs((_e139.z - 1f)));
                    break;
                }
            }
            let _e148 = i;
            let _e151 = i;
            let _e155 = intersect;
            let _e160 = intersect;
            let _e165 = intersect;
            let _e173 = intersect;
            if ((((((_e148 == 2i) || (_e151 == 3i)) && (_e155.x > 0f)) && (_e160.z > 0f)) && (_e165.x < 1f)) && (_e173.z < 1f)) {
                {
                    offset = 0f;
                    let _e183 = ro_3;
                    if (_e183.x < 0f) {
                        {
                            offset = 1f;
                        }
                    }
                    let _e191 = intersect;
                    let _e193 = offset;
                    let _e196 = intersect;
                    delta = min(abs((_e191.x - _e193)), abs((_e196.z - 1f)));
                    break;
                }
            }
            let _e205 = i;
            let _e208 = i;
            let _e212 = intersect;
            let _e217 = intersect;
            let _e222 = intersect;
            let _e230 = intersect;
            if ((((((_e205 == 4i) || (_e208 == 5i)) && (_e212.x > 0f)) && (_e217.y > 0f)) && (_e222.x < 1f)) && (_e230.y < 0.25f)) {
                {
                    offset_1 = 0f;
                    let _e240 = ro_3;
                    if (_e240.x < 0f) {
                        {
                            offset_1 = 1f;
                        }
                    }
                    let _e248 = intersect;
                    let _e250 = offset_1;
                    let _e253 = intersect;
                    delta = min(abs((_e248.x - _e250)), abs((_e253.y - 0.25f)));
                    break;
                }
            }
        }
        continuing {
            let _e84 = h;
            h = (_e84 + 1i);
        }
    }
    let _e262 = delta;
    if (_e262 == 0f) {
        {
            return vec2(0f);
        }
    }
    let _e267 = delta;
    let _e269 = intersect;
    let _e270 = ro_3;
    delta = (_e267 * (50f - distance(_e269, _e270)));
    normals[0i] = vec3<f32>(-1f, 0f, 0f);
    normals[1i] = vec3<f32>(1f, 0f, 0f);
    normals[2i] = vec3<f32>(0f, -1f, 0f);
    normals[3i] = vec3<f32>(0f, 1f, 0f);
    normals[4i] = vec3<f32>(0f, 0f, -1f);
    normals[5i] = vec3<f32>(0f, 0f, 1f);
    let _e314 = i;
    let _e316 = normals[_e314];
    normal_2 = _e316;
    let _e318 = secs_3;
    lighttime = (((f32(_e318) / 86400f) * TAU) - 1.5707964f);
    let _e329 = lighttime;
    let _e334 = lighttime;
    let _e340 = lighttime;
    lightpos_2 = vec3<f32>((5f - (cos(_e329) * 3f)), (max(sin(_e334), 0f) * 5f), (cos(_e340) * -10f));
    let _e348 = intersect;
    let _e349 = normal_2;
    let _e350 = lightpos_2;
    let _e351 = light(_e348, _e349, _e350);
    mainlight = (0.7f * _e351);
    let _e355 = intersect;
    let _e356 = normal_2;
    let _e362 = light(_e355, _e356, vec3<f32>(5f, 2f, -5f));
    ambientlight = (0.3f * _e362);
    let _e365 = lighttime;
    lightfactor = (((min(sin(_e365), 0f) * 0.8f) + 0.2f) + 1f);
    let _e376 = lightfactor;
    let _e377 = mainlight;
    let _e378 = ambientlight;
    let _e381 = delta;
    return vec2<f32>((_e376 * (_e377 + _e378)), min(_e381, 1f));
}

fn renderClouds(uv: vec2<f32>, secs_4: i32) -> vec2<f32> {
    var uv_1: vec2<f32>;
    var secs_5: i32;
    var result: vec2<f32> = vec2(0f);
    var rduv: vec2<f32>;
    var pos: f32 = 15f;
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
    let _e12 = uv_1;
    rduv = (_e12 - vec2(0.8f));
    let _e18 = rduv;
    let _e20 = iResolution;
    let _e22 = iResolution;
    rduv.x = (_e18.x * (_e20.x / _e22.y));
    let _e26 = rduv;
    rduv = (_e26 * 0.9f);
    let _e31 = rduv;
    rd_4 = normalize(vec3<f32>(_e31.x, _e31.y, 1f));
    loop {
        let _e41 = z;
        if !((_e41 <= -9f)) {
            break;
        }
        {
            offset_2 = 0i;
            let _e51 = pos;
            x_4 = _e51;
            i_1 = 0i;
            loop {
                let _e55 = x_4;
                let _e58 = z;
                if !((normalize(vec3<f32>(_e55, -1.2f, _e58)).x > -0.4f)) {
                    break;
                }
                {
                    let _e69 = x_4;
                    let _e72 = z;
                    ro_4 = vec3<f32>(_e69, -1.2f, _e72);
                    let _e75 = ro_4;
                    if (normalize(_e75).x > 0.9f) {
                        {
                            let _e80 = x_4;
                            let _e82 = z;
                            delta_1 = (floor(_e80) - (_e82 * -2f));
                            let _e88 = delta_1;
                            delta_1 = max(_e88, 1f);
                            let _e91 = offset_2;
                            let _e92 = delta_1;
                            offset_2 = (_e91 + i32(_e92));
                            let _e95 = x_4;
                            let _e96 = delta_1;
                            x_4 = (_e95 - _e96);
                            let _e98 = i_1;
                            i_1 = (_e98 - 1i);
                            continue;
                        }
                    }
                    let _e101 = x_4;
                    x_4 = (_e101 - 1f);
                    let _e104 = z;
                    let _e107 = i_1;
                    let _e108 = offset_2;
                    let _e111 = ((_e104 * 1.63287f) + f32((_e107 + _e108)));
                    let _e118 = rand((_e111 - (floor((_e111 / 1.4142135f)) * 1.4142135f)));
                    if (_e118 > CLOUD_CHANCE) {
                        {
                            continue;
                        }
                    }
                    let _e120 = ro_4;
                    let _e121 = rd_4;
                    let _e122 = secs_5;
                    let _e123 = renderCloud(_e120, _e121, _e122);
                    cloud = _e123;
                    let _e125 = cloud;
                    if (_e125.x > 0f) {
                        {
                            let _e129 = cloud;
                            result = _e129;
                        }
                    }
                }
                continuing {
                    let _e66 = i_1;
                    i_1 = (_e66 + 1i);
                }
            }
        }
        continuing {
            let _e46 = z;
            z = (_e46 + 1f);
        }
    }
    let _e130 = result;
    return _e130;
}

fn main_1() {
    var pos_1: vec2<f32>;
    var ipos: vec2<i32>;
    var secs_6: i32 = 30000i;
    var cloud_1: vec2<f32>;

    let _e7 = coord_1;
    pos_1 = _e7;
    let _e9 = coord_1;
    ipos = vec2<i32>(_e9);
    o_1 = vec4(0f);
    let _e16 = pos_1;
    if (_e16.y > 0.85f) {
        {
            let _e20 = pos_1;
            let _e21 = secs_6;
            let _e22 = renderClouds(_e20, _e21);
            cloud_1 = _e22;
            let _e24 = cloud_1;
            if (_e24.x > 0f) {
                {
                    let _e28 = o_1;
                    let _e29 = cloud_1;
                    let _e30 = _e29.xxx;
                    let _e36 = cloud_1;
                    o_1 = mix(_e28, vec4<f32>(_e30.x, _e30.y, _e30.z, 1f), vec4((_e36.y * 0.8f)));
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
fn main(@location(0) coord: vec2<f32>) -> FragmentOutput {
    coord_1 = coord;
    main_1();
    let _e22 = o_1;
    return FragmentOutput(_e22);
}
