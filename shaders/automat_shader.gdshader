shader_type canvas_item;

uniform float scale = 1.0;
uniform vec4 color1 = vec4(1.0, 0.0, 0.0, 1.0);
uniform vec4 color2 = vec4(0.0, 0.0, 1.0, 1.0);

float rand(vec2 co) {
    return fract(sin(dot(co.xy, vec2(12.9898, 78.233))) * 43758.5453);
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    
    float a = rand(i);
    float b = rand(i + vec2(1.0, 0.0));
    float c = rand(i + vec2(0.0, 1.0));
    float d = rand(i + vec2(1.0, 1.0));
    
    vec2 u = f * f * (3.0 - 2.0 * f);
    
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

void fragment() {
    vec2 uv = FRAGCOORD.xy / scale;
    
    
    float n = noise(uv);
    COLOR = mix(color1, color2, n);
}