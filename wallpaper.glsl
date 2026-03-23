// uniforms:
// vec3 iResolution
// float iTime
// float iTimeDelta
// float iFrameRate
// int iFrame
// float iChannelTime[4]
// vec3 iChannelResolution[4]
// vec4 iMouse
// vec4 iDate
// float iSampleRate

uniform sampler2D noise;

const float TAU = 6.2831853;
const float PI = TAU / 2.;

float rand(in float seed) {
    // return fract(sin(seed) * 43758.5453);
    seed = fract(seed * 0.1031);
    seed *= seed + 33.33;
    seed *= seed + seed;
    return fract(seed);
}

float square(in float n) {
    return n * n;
}

vec3 skycolor(in int secs) { // thank god for desmos
    if (secs < 28800) {
        float x = float(secs) / 28800.;
        float r = .3*x + .35;
        float g = .7*x + .15;
        float b = .9 - .8*square(x - 1.);
        float f = x + 0.82574; // x + sqrt(1 / 0.3) - 1, of course
        f *= .3*f;
        return f * vec3(r, g, b);
    } else if (secs < 57600) {
        float x = float(secs - 28800) / 28880.;
        float r = .65 - .3*x;
        float g;
        if (x < 0.4) { g = .898 - .3*square(x - .4); }
        else { g = .898 - square(x - .4); }
        float b = .1*x + .9;
        return vec3(r, g, b);
    } else if (secs < 72000) {
        float x = float(secs - 57600) / 14400.;
        float r = min(1., square(5.*x) + .35);
        float g = max(0., .538 - .6*x);
        float b = .2 / (x + .2);
        float f = min(1., 1.2 - x);
        return f * vec3(r, g, b);
    } else {
        float x = float(secs - 72000) / 14400.;
        float r = 1. - .65*x;
        float g = .15*x;
        float b;
        if (x < 0.77) { b = 1. - .69*square(2.*x - 1.1); }
        else { b = .91 - square(3.*x - 2.1); }
        float f = .2;
        return f * vec3(r, g, b);
    }
}

float light(vec3 raypos, vec3 normal, vec3 lightpos) {
    vec3 light = normalize(lightpos - raypos);
    float dif = dot(normal, light);
    dif = max(dif, 0.);
    dif *= 0.5;
    dif += 0.5;
    return dif;
}

const vec3 CLOUD_DIMENSIONS = vec3(1., 0.25, 1.);

vec3 intersectPlane(vec3 ro, vec3 rd, int type) { // type == 0 means x, 1 means y, and 2 means z
    float os[3]; os[0] = ro.x; os[1] = ro.y; os[2] = ro.z;
    float ds[3]; ds[0] = rd.x; ds[1] = rd.y; ds[2] = rd.z;
    float o = os[type];
    float d = ds[type];
    return ro - o * rd / d; // thank you ABSOLUTELY NO ONE I FIGURED THIS OUT MYSELF :DDD
}

vec4 intersectBox(vec3 ro, vec3 rd, vec3 dimensions) { // this function used to be MASSIVE
    vec3 ros[6];
    ros[0] = ro; ros[1] = ro - vec2(dimensions.x, 0.).xyy;
    ros[2] = ro; ros[3] = ro - vec2(dimensions.y, 0.).yxy;
    ros[4] = ro; ros[5] = ro - vec2(dimensions.z, 0.).yyx;
    int order[6]; order[0] = 4; order[1] = 2; order[2] = 1; order[3] = 0; order[4] = 3; order[5] = 5;
    int i;
    vec3 intersect = vec3(0.);
    for (int h = 0; h < 6; h++) {
        i = order[h];
        intersect = intersectPlane(ros[i], rd, i / 2);
        if (
            ((i == 0 || i == 1) && intersect.y > 0. && intersect.z > 0. && intersect.y < dimensions.y && intersect.z < dimensions.z) ||
            ((i == 2 || i == 3) && intersect.x > 0. && intersect.z > 0. && intersect.x < dimensions.x && intersect.z < dimensions.z) ||
            ((i == 4 || i == 5) && intersect.x > 0. && intersect.y > 0. && intersect.x < dimensions.x && intersect.y < dimensions.y)
        ) { return vec4(intersect, i); } // i is the side that collided, for use as a way to determine the normal in renderCloud
    }
    return vec4(0.);
}

float renderCloud(vec3 ro, vec3 rd, int secs) {
    vec4 result = intersectBox(ro, rd, CLOUD_DIMENSIONS);
    if (result == vec4(0.)) { return 0.; }
    vec3 intersect = result.xyz;
    vec3 normals[6];
    normals[0] = vec3(-1., 0., 0.);
    normals[1] = vec3(1., 0., 0.);
    normals[2] = vec3(0., -1., 0.);
    normals[3] = vec3(0., 1., 0.);
    normals[4] = vec3(0., 0., -1.);
    normals[5] = vec3(0., 0., 1.);
    vec3 normal = normals[int(result.w)];
    return 1.;
    float lighttime = ((float(secs) / 86400.) * TAU) - PI/2.;
    vec3 lightpos = vec3(
        5. - cos(lighttime) * 3.,
        max(sin(lighttime), 0.) * 5.,
        cos(lighttime) * -10.
    );
    float mainlight = 0.7 * light(intersect, normal, lightpos);
    float ambientlight = 0.3 * light(intersect, normal, vec3(5., 2., -5.));
    float lightfactor = min(sin(lighttime), 0.) * 0.8 + 0.2 + 1.;
    return lightfactor * (mainlight + ambientlight);
}

const float CLOUD_CHANCE = 0.05;

float renderClouds(vec2 uv, int secs) {
    float result = 0.;

    vec2 rduv = uv - 0.8;
    rduv.x *= iResolution.x / iResolution.y;
    float pos = iTime * 0.05 + 15.;
    vec3 rd = normalize(vec3(rduv, 1.));

    for (float z = -20.; z <= -9.; z++) {
        int offset = 0;
        float x = pos;
        for (int i = 0; normalize(vec3(x, -1.2, z)).x > -0.4; i++) {
            vec3 ro = vec3(x, -1.2, z);

            if (normalize(ro).x > 0.9) {
                float delta = floor(x) - z * -2.;
                delta = max(delta, 1.);
                offset += int(delta);
                x -= delta;
                i--;
                continue;
            }
            x--;
            if (rand(mod(z * 1.63287 + float(i + offset), sqrt(2.))) > CLOUD_CHANCE) { continue; }
            float cloud = renderCloud(ro, rd, secs);
            if (cloud > 0.) { result = cloud; }
        }
    }
    return result;
}

void mainImage(out vec4 o, in vec2 coord) {
    vec2 pos = coord / iResolution.xy;
    ivec2 ipos = ivec2(coord);
    // int secs = int(mod(iDate.w, 86400));
    // int secs = int(mod(iTime * 5000., 86400.));
    int secs = 50000;

    vec4 bgcolor = vec4(skycolor(secs), 1.);
    // bgcolor = vec4(vec3(0.), 1.);
    o = bgcolor;

    float cloud = renderClouds(pos, secs);
    if (cloud > 0.) { o = mix(o, vec4(vec3(cloud), 1.), 0.8); }

    vec2 adjpos = vec2(pos.x, pos.y * iResolution.y / iResolution.x);
    float t = mod(iTime * 0.25, 10.);
    // vec2 floatpos = vec2(sin(PI * t) + 2.*(t + 1.), 4. - cos(PI * t) - 0.5 * t) * 0.15;
    vec2 floatpos = vec2(0.1 - 0.1*cos(PI*t - 0.2) + 0.04*t, 0.9 + 0.1*smoothstep(0., 1., mod(-1.*t, 1.)) - 0.1*floor(t));
    floatpos.y *= iResolution.y / iResolution.x;
    if (distance(floatpos, adjpos) < 0.0025) {
        o = mix(o, vec4(0.3, 0.7, 0.1, 1.), 0.8);
    }
}
