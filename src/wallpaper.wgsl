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

fn rand(seed: f32) -> f32 {
    var seed_1: f32;

    seed_1 = seed;
    let _e10 = seed_1;
    seed_1 = fract((_e10 * 0.1031f));
    let _e14 = seed_1;
    let _e15 = seed_1;
    seed_1 = (_e14 * (_e15 + 33.33f));
    let _e19 = seed_1;
    let _e20 = seed_1;
    let _e21 = seed_1;
    seed_1 = (_e19 * (_e20 + _e21));
    let _e24 = seed_1;
    return fract(_e24);
}

fn square(n: f32) -> f32 {
    var n_1: f32;

    n_1 = n;
    let _e10 = n_1;
    let _e11 = n_1;
    return (_e10 * _e11);
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
    let _e10 = secs_1;
    if (_e10 < 28800i) {
        {
            let _e13 = secs_1;
            x = (f32(_e13) / 28800f);
            let _e19 = x;
            r = ((0.3f * _e19) + 0.35f);
            let _e25 = x;
            g = ((0.7f * _e25) + 0.15f);
            let _e32 = x;
            let _e35 = square((_e32 - 1f));
            b = (0.9f - (0.8f * _e35));
            let _e39 = x;
            f = (_e39 + 0.82574f);
            let _e43 = f;
            let _e45 = f;
            f = (_e43 * (0.3f * _e45));
            let _e48 = f;
            let _e49 = r;
            let _e50 = g;
            let _e51 = b;
            return (_e48 * vec3<f32>(_e49, _e50, _e51));
        }
    } else {
        let _e54 = secs_1;
        if (_e54 < 57600i) {
            {
                let _e57 = secs_1;
                x_1 = (f32((_e57 - 28800i)) / 28880f);
                let _e66 = x_1;
                r_1 = (0.65f - (0.3f * _e66));
                let _e71 = x_1;
                if (_e71 < 0.4f) {
                    {
                        let _e76 = x_1;
                        let _e79 = square((_e76 - 0.4f));
                        g_1 = (0.898f - (0.3f * _e79));
                    }
                } else {
                    {
                        let _e83 = x_1;
                        let _e86 = square((_e83 - 0.4f));
                        g_1 = (0.898f - _e86);
                    }
                }
                let _e89 = x_1;
                b_1 = ((0.1f * _e89) + 0.9f);
                let _e94 = r_1;
                let _e95 = g_1;
                let _e96 = b_1;
                return vec3<f32>(_e94, _e95, _e96);
            }
        } else {
            let _e98 = secs_1;
            if (_e98 < 72000i) {
                {
                    let _e101 = secs_1;
                    x_2 = (f32((_e101 - 57600i)) / 14400f);
                    let _e110 = x_2;
                    let _e112 = square((5f * _e110));
                    r_2 = min(1f, (_e112 + 0.35f));
                    let _e120 = x_2;
                    g_2 = max(0f, (0.538f - (0.6f * _e120)));
                    let _e126 = x_2;
                    b_2 = (0.2f / (_e126 + 0.2f));
                    let _e133 = x_2;
                    f_1 = min(1f, (1.2f - _e133));
                    let _e137 = f_1;
                    let _e138 = r_2;
                    let _e139 = g_2;
                    let _e140 = b_2;
                    return (_e137 * vec3<f32>(_e138, _e139, _e140));
                }
            } else {
                {
                    let _e143 = secs_1;
                    x_3 = (f32((_e143 - 72000i)) / 14400f);
                    let _e152 = x_3;
                    r_3 = (1f - (0.65f * _e152));
                    let _e157 = x_3;
                    g_3 = (0.15f * _e157);
                    let _e161 = x_3;
                    if (_e161 < 0.77f) {
                        {
                            let _e167 = x_3;
                            let _e171 = square(((2f * _e167) - 1.1f));
                            b_3 = (1f - (0.69f * _e171));
                        }
                    } else {
                        {
                            let _e176 = x_3;
                            let _e180 = square(((3f * _e176) - 2.1f));
                            b_3 = (0.91f - _e180);
                        }
                    }
                    let _e184 = f_2;
                    let _e185 = r_3;
                    let _e186 = g_3;
                    let _e187 = b_3;
                    return (_e184 * vec3<f32>(_e185, _e186, _e187));
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
    let _e14 = lightpos_1;
    let _e15 = raypos_1;
    light_1 = normalize((_e14 - _e15));
    let _e19 = normal_1;
    let _e20 = light_1;
    dif = dot(_e19, _e20);
    let _e23 = dif;
    dif = max(_e23, 0f);
    let _e26 = dif;
    dif = (_e26 * 0.5f);
    let _e29 = dif;
    dif = (_e29 + 0.5f);
    let _e32 = dif;
    return _e32;
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
    let _e18 = ro_1;
    os[0i] = _e18.x;
    let _e22 = ro_1;
    os[1i] = _e22.y;
    let _e26 = ro_1;
    os[2i] = _e26.z;
    let _e31 = rd_1;
    ds[0i] = _e31.x;
    let _e35 = rd_1;
    ds[1i] = _e35.y;
    let _e39 = rd_1;
    ds[2i] = _e39.z;
    let _e41 = type_20;
    let _e43 = os[_e41];
    o = _e43;
    let _e45 = type_20;
    let _e47 = ds[_e45];
    d = _e47;
    let _e49 = ro_1;
    let _e50 = o;
    let _e51 = rd_1;
    let _e53 = d;
    return (_e49 - ((_e50 * _e51) / vec3(_e53)));
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
    let _e18 = ro_3;
    ros[0i] = _e18;
    let _e21 = ro_3;
    ros[1i] = (_e21 - vec3<f32>(1f, 0f, 0f));
    let _e32 = ro_3;
    ros[2i] = _e32;
    let _e35 = ro_3;
    ros[3i] = (_e35 - vec3<f32>(0f, 0.25f, 0f));
    let _e46 = ro_3;
    ros[4i] = _e46;
    let _e49 = ro_3;
    ros[5i] = (_e49 - vec3<f32>(0f, 0f, 1f));
    order[0i] = 4i;
    order[1i] = 2i;
    order[2i] = 1i;
    order[3i] = 0i;
    order[4i] = 3i;
    order[5i] = 5i;
    loop {
        let _e85 = h;
        if !((_e85 < 6i)) {
            break;
        }
        {
            let _e92 = h;
            let _e94 = order[_e92];
            i = _e94;
            let _e95 = i;
            let _e97 = ros[_e95];
            let _e98 = rd_3;
            let _e99 = i;
            let _e102 = intersectPlane(_e97, _e98, (_e99 / 2i));
            intersect = _e102;
            let _e103 = i;
            let _e106 = i;
            let _e110 = intersect;
            let _e115 = intersect;
            let _e120 = intersect;
            let _e128 = intersect;
            if ((((((_e103 == 0i) || (_e106 == 1i)) && (_e110.y > 0f)) && (_e115.z > 0f)) && (_e120.y < 0.25f)) && (_e128.z < 1f)) {
                {
                    let _e136 = intersect;
                    deltay = abs((_e136.y - 0.25f));
                    let _e145 = intersect;
                    deltaz = abs((_e145.z - 1f));
                    let _e154 = deltay;
                    let _e155 = deltaz;
                    delta = min(_e154, _e155);
                    let _e157 = delta;
                    let _e160 = deltay;
                    let _e161 = deltaz;
                    if ((_e157 < 1f) && (_e160 > _e161)) {
                        {
                            delta = 1f;
                        }
                    }
                    break;
                }
            }
            let _e165 = i;
            let _e168 = i;
            let _e172 = intersect;
            let _e177 = intersect;
            let _e182 = intersect;
            let _e190 = intersect;
            if ((((((_e165 == 2i) || (_e168 == 3i)) && (_e172.x > 0f)) && (_e177.z > 0f)) && (_e182.x < 1f)) && (_e190.z < 1f)) {
                {
                    offset = 0f;
                    let _e200 = ro_3;
                    if (_e200.x < 0f) {
                        {
                            offset = 1f;
                        }
                    }
                    let _e208 = intersect;
                    let _e210 = offset;
                    let _e213 = intersect;
                    delta = min(abs((_e208.x - _e210)), abs((_e213.z - 1f)));
                    break;
                }
            }
            let _e222 = i;
            let _e225 = i;
            let _e229 = intersect;
            let _e234 = intersect;
            let _e239 = intersect;
            let _e247 = intersect;
            if ((((((_e222 == 4i) || (_e225 == 5i)) && (_e229.x > 0f)) && (_e234.y > 0f)) && (_e239.x < 1f)) && (_e247.y < 0.25f)) {
                {
                    offset_1 = 0f;
                    let _e257 = ro_3;
                    if (_e257.x < 0f) {
                        {
                            offset_1 = 1f;
                        }
                    }
                    let _e265 = intersect;
                    let _e267 = offset_1;
                    deltax = abs((_e265.x - _e267));
                    let _e271 = intersect;
                    deltay_1 = abs((_e271.y - 0.25f));
                    let _e280 = deltax;
                    let _e281 = deltay_1;
                    delta = min(_e280, _e281);
                    let _e283 = delta;
                    let _e286 = deltay_1;
                    let _e287 = deltax;
                    if ((_e283 < 1f) && (_e286 > _e287)) {
                        {
                            delta = 1f;
                        }
                    }
                    break;
                }
            }
        }
        continuing {
            let _e89 = h;
            h = (_e89 + 1i);
        }
    }
    let _e291 = delta;
    if (_e291 == 0f) {
        {
            return vec2(0f);
        }
    }
    let _e296 = delta;
    let _e298 = intersect;
    let _e299 = ro_3;
    delta = (_e296 * (50f - distance(_e298, _e299)));
    normals[0i] = vec3<f32>(-1f, 0f, 0f);
    normals[1i] = vec3<f32>(1f, 0f, 0f);
    normals[2i] = vec3<f32>(0f, -1f, 0f);
    normals[3i] = vec3<f32>(0f, 1f, 0f);
    normals[4i] = vec3<f32>(0f, 0f, -1f);
    normals[5i] = vec3<f32>(0f, 0f, 1f);
    let _e343 = i;
    let _e345 = normals[_e343];
    normal_2 = _e345;
    let _e347 = secs_3;
    lighttime = (((f32(_e347) / 86400f) * TAU) - 1.5707964f);
    let _e358 = lighttime;
    let _e363 = lighttime;
    let _e369 = lighttime;
    lightpos_2 = vec3<f32>((5f - (cos(_e358) * 3f)), (max(sin(_e363), 0f) * 5f), (cos(_e369) * -10f));
    let _e377 = intersect;
    let _e378 = normal_2;
    let _e379 = lightpos_2;
    let _e380 = light(_e377, _e378, _e379);
    mainlight = (0.7f * _e380);
    let _e384 = intersect;
    let _e385 = normal_2;
    let _e391 = light(_e384, _e385, vec3<f32>(5f, 2f, -5f));
    ambientlight = (0.3f * _e391);
    let _e394 = lighttime;
    lightfactor = (((min(sin(_e394), 0f) * 0.8f) + 0.2f) + 1f);
    let _e405 = lightfactor;
    let _e406 = mainlight;
    let _e407 = ambientlight;
    let _e410 = delta;
    return vec2<f32>((_e405 * (_e406 + _e407)), min(_e410, 1f));
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
    let _e17 = uv_1;
    rduv = (_e17 - vec2(0.8f));
    let _e23 = rduv;
    let _e25 = RESOLUTION_1;
    let _e27 = RESOLUTION_1;
    rduv.x = (_e23.x * (_e25.x / _e27.y));
    let _e31 = rduv;
    rduv = (_e31 * 0.9f);
    let _e34 = TIME_1;
    pos = ((_e34 * 0.1f) + 15f);
    let _e40 = rduv;
    rd_4 = normalize(vec3<f32>(_e40.x, _e40.y, 1f));
    loop {
        let _e50 = z;
        if !((_e50 <= -9f)) {
            break;
        }
        {
            offset_2 = 0i;
            let _e60 = pos;
            x_4 = _e60;
            i_1 = 0i;
            loop {
                let _e64 = x_4;
                let _e67 = z;
                if !((normalize(vec3<f32>(_e64, -1.2f, _e67)).x > -0.4f)) {
                    break;
                }
                {
                    let _e78 = x_4;
                    let _e81 = z;
                    ro_4 = vec3<f32>(_e78, -1.2f, _e81);
                    let _e84 = ro_4;
                    if (normalize(_e84).x > 0.9f) {
                        {
                            let _e89 = x_4;
                            let _e91 = z;
                            delta_1 = (floor(_e89) - (_e91 * -2f));
                            let _e97 = delta_1;
                            delta_1 = max(_e97, 1f);
                            let _e100 = offset_2;
                            let _e101 = delta_1;
                            offset_2 = (_e100 + i32(_e101));
                            let _e104 = x_4;
                            let _e105 = delta_1;
                            x_4 = (_e104 - _e105);
                            let _e107 = i_1;
                            i_1 = (_e107 - 1i);
                            continue;
                        }
                    }
                    let _e110 = x_4;
                    x_4 = (_e110 - 1f);
                    let _e113 = z;
                    let _e116 = i_1;
                    let _e117 = offset_2;
                    let _e120 = ((_e113 * 1.63287f) + f32((_e116 + _e117)));
                    let _e127 = rand((_e120 - (floor((_e120 / 1.4142135f)) * 1.4142135f)));
                    if (_e127 > CLOUD_CHANCE) {
                        {
                            continue;
                        }
                    }
                    let _e129 = ro_4;
                    let _e130 = rd_4;
                    let _e131 = secs_5;
                    let _e132 = renderCloud(_e129, _e130, _e131);
                    cloud = _e132;
                    let _e134 = cloud;
                    if (_e134.x > 0f) {
                        {
                            let _e138 = cloud;
                            result = _e138;
                        }
                    }
                }
                continuing {
                    let _e75 = i_1;
                    i_1 = (_e75 + 1i);
                }
            }
        }
        continuing {
            let _e55 = z;
            z = (_e55 + 1f);
        }
    }
    let _e139 = result;
    return _e139;
}

fn grassHeight(x_5: f32) -> f32 {
    var x_6: f32;

    x_6 = x_5;
    let _e15 = x_6;
    return ((smoothstep(0.2f, 1f, (1f - _e15)) * 0.2f) + 0.07f);
}

fn grassPos(i_2: i32) -> vec2<f32> {
    var i_3: i32;
    var x_7: f32;

    i_3 = i_2;
    let _e15 = i_3;
    let _e22 = i_3;
    let _e24 = rand(f32(_e22));
    x_7 = ((f32(_e15) / 201f) + (_e24 * GRASSOFFSETWIDTH));
    let _e28 = x_7;
    let _e29 = x_7;
    let _e30 = grassHeight(_e29);
    return vec2<f32>(_e28, _e30);
}

fn renderGrasses() -> vec4<f32> {
    var i_4: i32 = 0i;
    var grasspos: vec2<f32>;
    var offset_3: f32;

    loop {
        let _e17 = i_4;
        if !((_e17 <= NUMGRASSES)) {
            break;
        }
        {
            let _e23 = i_4;
            let _e24 = grassPos(_e23);
            grasspos = _e24;
            let _e27 = coord_1;
            let _e29 = grasspos;
            let _e32 = square((_e27.y - _e29.y));
            let _e34 = NOISE_1;
            let _e36 = i_4;
            let _e38 = rand(f32(_e36));
            offset_3 = (((0.8f * _e32) * _e34) * ((_e38 * 0.4f) + 0.6f));
            let _e45 = coord_1;
            let _e47 = grasspos;
            let _e49 = offset_3;
            let _e52 = coord_1;
            let _e54 = grasspos;
            let _e56 = offset_3;
            let _e61 = coord_1;
            let _e63 = grasspos;
            let _e66 = i_4;
            let _e68 = rand(f32(_e66));
            if (((_e45.x > (_e47.x + _e49)) && (_e52.x < ((_e54.x + _e56) + GRASSWIDTH))) && (_e61.y < ((_e63.y + GRASSHEIGHT) + (_e68 * GRASSOFFSETHEIGHT)))) {
                {
                    let _e75 = i_4;
                    let _e79 = rand((f32(_e75) + 0.1f));
                    return vec4<f32>(0f, (0.5f + (_e79 * 0.05f)), 0f, 1f);
                }
            }
        }
        continuing {
            let _e20 = i_4;
            i_4 = (_e20 + 1i);
        }
    }
    return vec4(0f);
}

fn main_1() {
    var secs_6: i32;
    var cloud_1: vec2<f32>;
    var grassheight: f32;
    var grass: vec4<f32>;

    let _e15 = TIME_1;
    let _e17 = (_e15 * 5000f);
    secs_6 = i32((_e17 - (floor((_e17 / 86400f)) * 86400f)));
    o_1 = vec4(0f);
    let _e27 = coord_1;
    if (_e27.y > 0.862f) {
        {
            let _e31 = coord_1;
            let _e32 = secs_6;
            let _e33 = renderClouds(_e31, _e32);
            cloud_1 = _e33;
            let _e35 = cloud_1;
            if (_e35.x > 0f) {
                {
                    let _e39 = o_1;
                    let _e40 = cloud_1;
                    let _e41 = _e40.xxx;
                    let _e47 = cloud_1;
                    o_1 = mix(_e39, vec4<f32>(_e41.x, _e41.y, _e41.z, 1f), vec4((_e47.y * 0.8f)));
                }
            }
        }
    }
    let _e53 = coord_1;
    let _e55 = grassHeight(_e53.x);
    grassheight = _e55;
    let _e57 = coord_1;
    let _e59 = grassheight;
    let _e61 = coord_1;
    let _e63 = grassheight;
    if ((_e57.y > _e59) && (_e61.y < ((_e63 + GRASSHEIGHT) + GRASSOFFSETHEIGHT))) {
        {
            let _e68 = renderGrasses();
            grass = _e68;
            let _e70 = grass;
            if (_e70.w > 0f) {
                {
                    let _e74 = grass;
                    o_1 = _e74;
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
fn main(@location(0) coord: vec2<f32>, @location(1) RESOLUTION: vec2<f32>, @location(2) TIME: f32, @location(3) RAND: f32, @location(4) NOISE: f32) -> FragmentOutput {
    coord_1 = coord;
    RESOLUTION_1 = RESOLUTION;
    TIME_1 = TIME;
    RAND_1 = RAND;
    NOISE_1 = NOISE;
    main_1();
    let _e41 = o_1;
    return FragmentOutput(_e41);
}
