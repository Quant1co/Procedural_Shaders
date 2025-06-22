shader_type canvas_item;

uniform sampler2D noise_texture; // Ссылка на NoiseTexture2D
uniform float scale : hint_range(0.1, 10.0) = 3.0;
void fragment() {
    vec4 noise_color = texture(noise_texture, UV * 10.0); // Сэмплируем текстуру шума
    float noise = noise_color.r; // Используем красный канал для значения шума
    COLOR = vec4(vec3(noise * 0.5 + 0.5), 1.0); // Применяем шум к цвету
}