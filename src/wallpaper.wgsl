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

fn rand(seed: f32) -> f32 {
    var seed_1: f32;

    seed_1 = seed;
    let _e11 = seed_1;
    seed_1 = fract((_e11 * 0.1031f));
    let _e15 = seed_1;
    let _e16 = seed_1;
    seed_1 = (_e15 * (_e16 + 33.33f));
    let _e20 = seed_1;
    let _e21 = seed_1;
    let _e22 = seed_1;
    seed_1 = (_e20 * (_e21 + _e22));
    let _e25 = seed_1;
    return fract(_e25);
}

fn square(n: f32) -> f32 {
    var n_1: f32;

    n_1 = n;
    let _e11 = n_1;
    let _e12 = n_1;
    return (_e11 * _e12);
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
    let _e11 = secs_1;
    if (_e11 < 28800u) {
        {
            let _e15 = secs_1;
            x = (f32(_e15) / 28800f);
            let _e21 = x;
            r = ((0.3f * _e21) + 0.35f);
            let _e27 = x;
            g = ((0.7f * _e27) + 0.15f);
            let _e34 = x;
            let _e37 = square((_e34 - 1f));
            b = (0.9f - (0.8f * _e37));
            let _e41 = x;
            f = (_e41 + 0.82574f);
            let _e45 = f;
            let _e47 = f;
            f = (_e45 * (0.3f * _e47));
            let _e50 = f;
            let _e51 = r;
            let _e52 = g;
            let _e53 = b;
            return (_e50 * vec3<f32>(_e51, _e52, _e53));
        }
    } else {
        let _e56 = secs_1;
        if (_e56 < 57600u) {
            {
                let _e60 = secs_1;
                x_1 = (f32((_e60 - 28800u)) / 28880f);
                let _e70 = x_1;
                r_1 = (0.65f - (0.3f * _e70));
                let _e75 = x_1;
                if (_e75 < 0.4f) {
                    {
                        let _e80 = x_1;
                        let _e83 = square((_e80 - 0.4f));
                        g_1 = (0.898f - (0.3f * _e83));
                    }
                } else {
                    {
                        let _e87 = x_1;
                        let _e90 = square((_e87 - 0.4f));
                        g_1 = (0.898f - _e90);
                    }
                }
                let _e93 = x_1;
                b_1 = ((0.1f * _e93) + 0.9f);
                let _e98 = r_1;
                let _e99 = g_1;
                let _e100 = b_1;
                return vec3<f32>(_e98, _e99, _e100);
            }
        } else {
            let _e102 = secs_1;
            if (_e102 < 72000u) {
                {
                    let _e106 = secs_1;
                    x_2 = (f32((_e106 - 57600u)) / 14400f);
                    let _e116 = x_2;
                    let _e118 = square((5f * _e116));
                    r_2 = min(1f, (_e118 + 0.35f));
                    let _e126 = x_2;
                    g_2 = max(0f, (0.538f - (0.6f * _e126)));
                    let _e132 = x_2;
                    b_2 = (0.2f / (_e132 + 0.2f));
                    let _e139 = x_2;
                    f_1 = min(1f, (1.2f - _e139));
                    let _e143 = f_1;
                    let _e144 = r_2;
                    let _e145 = g_2;
                    let _e146 = b_2;
                    return (_e143 * vec3<f32>(_e144, _e145, _e146));
                }
            } else {
                {
                    let _e149 = secs_1;
                    x_3 = (f32((_e149 - 72000u)) / 14400f);
                    let _e159 = x_3;
                    r_3 = (1f - (0.65f * _e159));
                    let _e164 = x_3;
                    g_3 = (0.15f * _e164);
                    let _e168 = x_3;
                    if (_e168 < 0.77f) {
                        {
                            let _e174 = x_3;
                            let _e178 = square(((2f * _e174) - 1.1f));
                            b_3 = (1f - (0.69f * _e178));
                        }
                    } else {
                        {
                            let _e183 = x_3;
                            let _e187 = square(((3f * _e183) - 2.1f));
                            b_3 = (0.91f - _e187);
                        }
                    }
                    let _e191 = f_2;
                    let _e192 = r_3;
                    let _e193 = g_3;
                    let _e194 = b_3;
                    return (_e191 * vec3<f32>(_e192, _e193, _e194));
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
    let _e15 = lightpos_1;
    let _e16 = raypos_1;
    light_1 = normalize((_e15 - _e16));
    let _e20 = normal_1;
    let _e21 = light_1;
    dif = dot(_e20, _e21);
    let _e24 = dif;
    dif = max(_e24, 0f);
    let _e27 = dif;
    dif = (_e27 * 0.5f);
    let _e30 = dif;
    dif = (_e30 + 0.5f);
    let _e33 = dif;
    return _e33;
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
    let _e19 = ro_1;
    os[0i] = _e19.x;
    let _e23 = ro_1;
    os[1i] = _e23.y;
    let _e27 = ro_1;
    os[2i] = _e27.z;
    let _e32 = rd_1;
    ds[0i] = _e32.x;
    let _e36 = rd_1;
    ds[1i] = _e36.y;
    let _e40 = rd_1;
    ds[2i] = _e40.z;
    let _e42 = type_20;
    let _e44 = os[_e42];
    o = _e44;
    let _e46 = type_20;
    let _e48 = ds[_e46];
    d = _e48;
    let _e50 = ro_1;
    let _e51 = o;
    let _e52 = rd_1;
    let _e54 = d;
    return (_e50 - ((_e51 * _e52) / vec3(_e54)));
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
    let _e19 = ro_3;
    ros[0i] = _e19;
    let _e22 = ro_3;
    ros[1i] = (_e22 - vec3<f32>(1f, 0f, 0f));
    let _e33 = ro_3;
    ros[2i] = _e33;
    let _e36 = ro_3;
    ros[3i] = (_e36 - vec3<f32>(0f, 0.25f, 0f));
    let _e47 = ro_3;
    ros[4i] = _e47;
    let _e50 = ro_3;
    ros[5i] = (_e50 - vec3<f32>(0f, 0f, 1f));
    order[0i] = 4i;
    order[1i] = 2i;
    order[2i] = 1i;
    order[3i] = 0i;
    order[4i] = 3i;
    order[5i] = 5i;
    loop {
        let _e86 = h;
        if !((_e86 < 6i)) {
            break;
        }
        {
            let _e93 = h;
            let _e95 = order[_e93];
            i = _e95;
            let _e96 = i;
            let _e98 = ros[_e96];
            let _e99 = rd_3;
            let _e100 = i;
            let _e103 = intersectPlane(_e98, _e99, (_e100 / 2i));
            intersect = _e103;
            let _e104 = i;
            let _e107 = i;
            let _e111 = intersect;
            let _e116 = intersect;
            let _e121 = intersect;
            let _e129 = intersect;
            if ((((((_e104 == 0i) || (_e107 == 1i)) && (_e111.y > 0f)) && (_e116.z > 0f)) && (_e121.y < 0.25f)) && (_e129.z < 1f)) {
                {
                    let _e137 = intersect;
                    deltay = abs((_e137.y - 0.25f));
                    let _e146 = intersect;
                    deltaz = abs((_e146.z - 1f));
                    let _e155 = deltay;
                    let _e156 = deltaz;
                    delta = min(_e155, _e156);
                    let _e158 = delta;
                    let _e161 = deltay;
                    let _e162 = deltaz;
                    if ((_e158 < 1f) && (_e161 > _e162)) {
                        {
                            delta = 1f;
                        }
                    }
                    break;
                }
            }
            let _e166 = i;
            let _e169 = i;
            let _e173 = intersect;
            let _e178 = intersect;
            let _e183 = intersect;
            let _e191 = intersect;
            if ((((((_e166 == 2i) || (_e169 == 3i)) && (_e173.x > 0f)) && (_e178.z > 0f)) && (_e183.x < 1f)) && (_e191.z < 1f)) {
                {
                    offset = 0f;
                    let _e201 = ro_3;
                    if (_e201.x < 0f) {
                        {
                            offset = 1f;
                        }
                    }
                    let _e209 = intersect;
                    let _e211 = offset;
                    let _e214 = intersect;
                    delta = min(abs((_e209.x - _e211)), abs((_e214.z - 1f)));
                    break;
                }
            }
            let _e223 = i;
            let _e226 = i;
            let _e230 = intersect;
            let _e235 = intersect;
            let _e240 = intersect;
            let _e248 = intersect;
            if ((((((_e223 == 4i) || (_e226 == 5i)) && (_e230.x > 0f)) && (_e235.y > 0f)) && (_e240.x < 1f)) && (_e248.y < 0.25f)) {
                {
                    offset_1 = 0f;
                    let _e258 = ro_3;
                    if (_e258.x < 0f) {
                        {
                            offset_1 = 1f;
                        }
                    }
                    let _e266 = intersect;
                    let _e268 = offset_1;
                    deltax = abs((_e266.x - _e268));
                    let _e272 = intersect;
                    deltay_1 = abs((_e272.y - 0.25f));
                    let _e281 = deltax;
                    let _e282 = deltay_1;
                    delta = min(_e281, _e282);
                    let _e284 = delta;
                    let _e287 = deltay_1;
                    let _e288 = deltax;
                    if ((_e284 < 1f) && (_e287 > _e288)) {
                        {
                            delta = 1f;
                        }
                    }
                    break;
                }
            }
        }
        continuing {
            let _e90 = h;
            h = (_e90 + 1i);
        }
    }
    let _e292 = delta;
    if (_e292 == 0f) {
        {
            return vec2(0f);
        }
    }
    let _e297 = delta;
    let _e299 = intersect;
    let _e300 = ro_3;
    delta = (_e297 * (50f - distance(_e299, _e300)));
    normals[0i] = vec3<f32>(-1f, 0f, 0f);
    normals[1i] = vec3<f32>(1f, 0f, 0f);
    normals[2i] = vec3<f32>(0f, -1f, 0f);
    normals[3i] = vec3<f32>(0f, 1f, 0f);
    normals[4i] = vec3<f32>(0f, 0f, -1f);
    normals[5i] = vec3<f32>(0f, 0f, 1f);
    let _e344 = i;
    let _e346 = normals[_e344];
    normal_2 = _e346;
    let _e348 = secs_3;
    lighttime = (((f32(_e348) / 86400f) * TAU) - 1.5707964f);
    let _e359 = lighttime;
    let _e364 = lighttime;
    let _e370 = lighttime;
    lightpos_2 = vec3<f32>((5f - (cos(_e359) * 3f)), (max(sin(_e364), 0f) * 5f), (cos(_e370) * -10f));
    let _e378 = intersect;
    let _e379 = normal_2;
    let _e380 = lightpos_2;
    let _e381 = light(_e378, _e379, _e380);
    mainlight = (0.7f * _e381);
    let _e385 = intersect;
    let _e386 = normal_2;
    let _e392 = light(_e385, _e386, vec3<f32>(5f, 2f, -5f));
    ambientlight = (0.3f * _e392);
    let _e395 = lighttime;
    lightfactor = (((min(sin(_e395), 0f) * 0.8f) + 0.2f) + 1f);
    let _e406 = lightfactor;
    let _e407 = mainlight;
    let _e408 = ambientlight;
    let _e411 = delta;
    return vec2<f32>((_e406 * (_e407 + _e408)), min(_e411, 1f));
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
    let _e18 = uv_1;
    rduv = (_e18 - vec2(0.8f));
    let _e24 = rduv;
    let _e26 = RESOLUTION_1;
    let _e28 = RESOLUTION_1;
    rduv.x = (_e24.x * (_e26.x / _e28.y));
    let _e32 = rduv;
    rduv = (_e32 * 0.9f);
    let _e35 = TIME_1;
    pos = ((_e35 * 0.1f) + 15f);
    let _e41 = rduv;
    rd_4 = normalize(vec3<f32>(_e41.x, _e41.y, 1f));
    loop {
        let _e51 = z;
        if !((_e51 <= -9f)) {
            break;
        }
        {
            offset_2 = 0i;
            let _e61 = pos;
            x_4 = _e61;
            i_1 = 0i;
            loop {
                let _e65 = x_4;
                let _e68 = z;
                if !((normalize(vec3<f32>(_e65, -1.2f, _e68)).x > -0.4f)) {
                    break;
                }
                {
                    let _e79 = x_4;
                    let _e82 = z;
                    ro_4 = vec3<f32>(_e79, -1.2f, _e82);
                    let _e85 = ro_4;
                    if (normalize(_e85).x > 0.9f) {
                        {
                            let _e90 = x_4;
                            let _e92 = z;
                            delta_1 = (floor(_e90) - (_e92 * -2f));
                            let _e98 = delta_1;
                            delta_1 = max(_e98, 1f);
                            let _e101 = offset_2;
                            let _e102 = delta_1;
                            offset_2 = (_e101 + i32(_e102));
                            let _e105 = x_4;
                            let _e106 = delta_1;
                            x_4 = (_e105 - _e106);
                            let _e108 = i_1;
                            i_1 = (_e108 - 1i);
                            continue;
                        }
                    }
                    let _e111 = x_4;
                    x_4 = (_e111 - 1f);
                    let _e114 = z;
                    let _e117 = i_1;
                    let _e118 = offset_2;
                    let _e121 = ((_e114 * 1.63287f) + f32((_e117 + _e118)));
                    let _e128 = rand((_e121 - (floor((_e121 / 1.4142135f)) * 1.4142135f)));
                    if (_e128 > CLOUD_CHANCE) {
                        {
                            continue;
                        }
                    }
                    let _e130 = ro_4;
                    let _e131 = rd_4;
                    let _e132 = secs_5;
                    let _e133 = renderCloud(_e130, _e131, _e132);
                    cloud = _e133;
                    let _e135 = cloud;
                    if (_e135.x > 0f) {
                        {
                            let _e139 = cloud;
                            result = _e139;
                        }
                    }
                }
                continuing {
                    let _e76 = i_1;
                    i_1 = (_e76 + 1i);
                }
            }
        }
        continuing {
            let _e56 = z;
            z = (_e56 + 1f);
        }
    }
    let _e140 = result;
    return _e140;
}

fn grassHeight(x_5: f32) -> f32 {
    var x_6: f32;

    x_6 = x_5;
    let _e16 = x_6;
    return ((smoothstep(0.2f, 1f, (1f - _e16)) * 0.2f) + 0.07f);
}

fn grassPos(i_2: i32) -> vec2<f32> {
    var i_3: i32;
    var x_7: f32;

    i_3 = i_2;
    let _e16 = i_3;
    let _e23 = i_3;
    let _e25 = rand(f32(_e23));
    x_7 = ((f32(_e16) / 201f) + (_e25 * GRASSOFFSETWIDTH));
    let _e29 = x_7;
    let _e30 = x_7;
    let _e31 = grassHeight(_e30);
    return vec2<f32>(_e29, _e31);
}

fn renderGrasses() -> vec4<f32> {
    var i_4: i32 = 0i;
    var grasspos: vec2<f32>;
    var offset_3: f32;

    loop {
        let _e18 = i_4;
        if !((_e18 <= NUMGRASSES)) {
            break;
        }
        {
            let _e24 = i_4;
            let _e25 = grassPos(_e24);
            grasspos = _e25;
            let _e28 = coord_1;
            let _e30 = grasspos;
            let _e33 = square((_e28.y - _e30.y));
            let _e35 = NOISE_1;
            let _e37 = i_4;
            let _e39 = rand(f32(_e37));
            offset_3 = (((1f * _e33) * _e35) * ((_e39 * 0.4f) + 0.6f));
            let _e46 = coord_1;
            let _e48 = grasspos;
            let _e50 = offset_3;
            let _e53 = coord_1;
            let _e55 = grasspos;
            let _e57 = offset_3;
            let _e62 = coord_1;
            let _e64 = grasspos;
            let _e67 = i_4;
            let _e69 = rand(f32(_e67));
            if (((_e46.x > (_e48.x + _e50)) && (_e53.x < ((_e55.x + _e57) + GRASSWIDTH))) && (_e62.y < ((_e64.y + GRASSHEIGHT) + (_e69 * GRASSOFFSETHEIGHT)))) {
                {
                    let _e76 = i_4;
                    let _e80 = rand((f32(_e76) + 0.1f));
                    return vec4<f32>(0f, (0.5f + (_e80 * 0.05f)), 0f, 1f);
                }
            }
        }
        continuing {
            let _e21 = i_4;
            i_4 = (_e21 + 1i);
        }
    }
    return vec4(0f);
}

fn main_1() {
    var secs_6: u32;
    var cloud_1: vec2<f32>;
    var grassheight: f32;
    var grass: vec4<f32>;

    let _e16 = DATETIME_1;
    secs_6 = _e16.w;
    o_1 = vec4(0f);
    let _e21 = coord_1;
    if (_e21.y > 0.862f) {
        {
            let _e25 = coord_1;
            let _e26 = secs_6;
            let _e27 = renderClouds(_e25, _e26);
            cloud_1 = _e27;
            let _e29 = cloud_1;
            if (_e29.x > 0f) {
                {
                    let _e33 = o_1;
                    let _e34 = cloud_1;
                    let _e35 = _e34.xxx;
                    let _e41 = cloud_1;
                    o_1 = mix(_e33, vec4<f32>(_e35.x, _e35.y, _e35.z, 1f), vec4((_e41.y * 0.8f)));
                }
            }
        }
    }
    let _e47 = coord_1;
    let _e49 = grassHeight(_e47.x);
    grassheight = _e49;
    let _e51 = coord_1;
    let _e53 = grassheight;
    let _e55 = coord_1;
    let _e57 = grassheight;
    if ((_e51.y > _e53) && (_e55.y < ((_e57 + GRASSHEIGHT) + GRASSOFFSETHEIGHT))) {
        {
            let _e62 = renderGrasses();
            grass = _e62;
            let _e64 = grass;
            if (_e64.w > 0f) {
                {
                    let _e68 = grass;
                    o_1 = _e68;
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
fn main(@location(0) coord: vec2<f32>, @location(1) RESOLUTION: vec2<f32>, @location(2) TIME: f32, @location(3) RAND: f32, @location(4) NOISE: f32, @location(5) @interpolate(flat) DATETIME: vec4<u32>) -> FragmentOutput {
    coord_1 = coord;
    RESOLUTION_1 = RESOLUTION;
    TIME_1 = TIME;
    RAND_1 = RAND;
    NOISE_1 = NOISE;
    DATETIME_1 = DATETIME;
    main_1();
    let _e45 = o_1;
    return FragmentOutput(_e45);
}
