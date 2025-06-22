shader_type canvas_item;
float rand(vec2 co) {
    return fract(sin(dot(co.xy, vec2(12.9898, 78.233))) * 43758.5453);
}
void fragment() {
    float noise = rand(UV);
    COLOR = vec4(vec3(noise), 1.0);
}