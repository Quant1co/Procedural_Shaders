shader_type canvas_item;

// Настройки
uniform float scale = 1.0;          // Масштаб текстуры
uniform float threshold = 0.5;      // Порог для стен (0-1)
uniform int iterations = 10;          // Итерации сглаживания
uniform vec4 wall_color: source_color = vec4(0.2, 0.15, 0.1, 1.0); // Цвет стен
uniform vec4 floor_color: source_color = vec4(0.3, 0.25, 0.2, 1.0); // Цвет пола

// Функция для генерации случайного значения
float random(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898, 78.233))) * 43758.5453123);
}

// Функция для генерации клеточного шума
float cellular_noise(vec2 uv) {
    uv *= scale;
    vec2 iuv = floor(uv);
    vec2 fuv = fract(uv);

    float min_dist = 1.0;

    // Проверяем соседние клетки
    for (int x = -1; x <= 1; x++) {
        for (int y = -1; y <= 1; y++) {
            // Преобразуем int в float для создания vec2
            vec2 neighbor = vec2(float(x), float(y));
            vec2 point = 0.5 + 0.5 * sin(
                random(iuv + neighbor) * 6.2831 + vec2(0.0, 1.6)
            );
            vec2 diff = neighbor + point - fuv;
            float dist = length(diff);
            min_dist = min(min_dist, dist);
        }
    }
    return min_dist;
}

void fragment() {
    vec2 uv = UV;
    float noise_val = 0.0;

    // Применяем несколько итераций шума
    for (int i = 0; i < iterations; i++) {
        float factor = pow(2.0, float(i));
        noise_val += cellular_noise(uv * factor + vec2(float(i) * 100.0)) / factor;
    }

    // Нормализуем значение
    noise_val /= 1.5;

    // Применяем пороговое значение
    float border = smoothstep(threshold - 0.1, threshold + 0.1, noise_val);

    // Смешиваем цвета
    vec4 color = mix(wall_color, floor_color, border);

    // Добавляем вариации цвета
    color.rgb *= 0.9 + 0.2 * random(uv + vec2(noise_val));

    COLOR = color;
}