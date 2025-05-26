shader_type canvas_item;

uniform vec3 base_color: source_color = vec3(0.5, 0.5, 0.5); // Базовый цвет асфальта (серый)
uniform float low_freq = 5.0;                  // Частота низкочастотного шума
uniform float high_freq = 50.0;                // Частота высокочастотного шума
uniform float graininess = 0.1;                // Уровень зернистости

float hash(vec2 p) {
    p = 50.0 * fract(p * 0.3183099 + vec2(0.71, 0.113));
    return -1.0 + 2.0 * fract(p.x * p.y * (p.x + p.y));
}

float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    vec2 u = f * f * (3.0 - 2.0 * f); // Плавная интерполяция
    return mix(mix(hash(i + vec2(0.0, 0.0)), hash(i + vec2(1.0, 0.0)), u.x),
               mix(hash(i + vec2(0.0, 1.0)), hash(i + vec2(1.0, 1.0)), u.x), u.y);
}

void fragment() {
    vec2 uv = UV;
    float n1 = noise(uv * low_freq);          // Низкочастотный шум
    float n2 = noise(uv * high_freq);         // Высокочастотный шум
    vec3 color = base_color + vec3(0.05 * n1 + 0.05 * graininess * n2); // Комбинируем шум с базовым цветом
    COLOR = vec4(color, 1.0);                 // Устанавливаем итоговый цвет
}