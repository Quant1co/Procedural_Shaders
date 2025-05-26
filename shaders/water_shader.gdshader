shader_type spatial;
render_mode unshaded;

// Настраиваемые параметры
uniform vec4 base_color : source_color = vec4(0.8, 0.8, 0.8, 1.0);
uniform vec4 line_color : source_color = vec4(0.2, 0.2, 0.2, 1.0);
uniform vec4 dark_color : source_color = vec4(0.1, 0.1, 0.1, 1.0);
uniform float scale = 12.0; // Увеличили масштаб для мелких деталей
uniform float line_width = 0.015; // Уменьшили ширину линий
uniform vec2 offset = vec2(0.03, 0.03);

// Параметры волн
uniform float wave_speed = 1.2;
uniform float global_height = 0.25; // Общая высота волн
uniform vec2 wave_direction = vec2(0.8, 0.3);
uniform float primary_frequency = 1.5;  // Основные крупные волны
uniform float secondary_frequency = 3.0; // Вторичные средние волны
uniform float tertiary_frequency = 6.0;  // Мелкая рябь

// Генератор псевдослучайных значений
vec2 random2(vec2 st) {
    st = vec2(
        dot(st, vec2(127.1, 311.7)),
        dot(st, vec2(269.5, 183.3))
    );
    return fract(sin(st) * 43758.5453123);
}

// Функция расчета границ
float calculate_edge(vec2 uv) {
    vec2 i_uv = floor(uv);
    vec2 f_uv = fract(uv);

    float min_dist = 1.0;
    float second_dist = 1.0;

    for(int x = -1; x <= 1; x++) {
        for(int y = -1; y <= 1; y++) {
            vec2 neighbor = vec2(float(x), float(y));
            vec2 point = random2(i_uv + neighbor);
            vec2 diff = neighbor + point - f_uv;
            float dist = length(diff);

            if(dist < min_dist) {
                second_dist = min_dist;
                min_dist = dist;
            } else if(dist < second_dist) {
                second_dist = dist;
            }
        }
    }
    return smoothstep(0.0, line_width, second_dist - min_dist);
}

// Новая функция генерации многослойных волн
float layered_wave(vec2 position, float time) {
    // Основная волна (крупная)
    float wave1 = sin(
        position.x * primary_frequency * 0.8 +
        position.y * primary_frequency * 0.6 +
        time * 1.5
    ) * 0.5;

    // Вторичная волна (средняя)
    float wave2 = cos(
        position.x * secondary_frequency * 1.2 -
        position.y * secondary_frequency * 0.9 +
        time * 2.3
    ) * 0.3;

    // Третичная волна (мелкая рябь)
    float wave3 = sin(
        (position.x + sin(time * 0.7)) * tertiary_frequency * 2.5 +
        (position.y + cos(time * 0.9)) * tertiary_frequency * 1.8 +
        time * 3.5
    ) * 0.15;

    // Комбинируем волны с разными весами
    return (wave1 * 0.6 + wave2 * 0.3 + wave3 * 0.1);
}

void vertex() {
    vec3 pos = VERTEX;
    float time = TIME * wave_speed;

    // Рассчитываем многослойные волны
    vec2 wave_pos = pos.xz * 0.5 + wave_direction * time;
    float height = layered_wave(wave_pos, time) * global_height;

    // Добавляем боковое смещение для реалистичности
    pos.xz += vec2(
        sin(wave_pos.x * primary_frequency + time),
        cos(wave_pos.y * primary_frequency * 0.8 + time)
    ) * global_height * 0.3;

    pos.y += height;
    VERTEX = pos;
}

void fragment() {
    float time = TIME * wave_speed * 0.7;
    vec2 animated_uv = UV * scale + wave_direction * time * 0.5;

    // Добавляем микродеформации UV для мелкой ряби
    vec2 ripple_uv = animated_uv + vec2(
        sin(time * 2.5 + UV.x * tertiary_frequency) * 0.1,
        cos(time * 2.2 + UV.y * tertiary_frequency) * 0.1
    );

    // Многоуровневый расчет границ
    float dark_edge = calculate_edge((ripple_uv + offset) * 1.2);
    vec4 bg_color = mix(dark_color, base_color, dark_edge);

    float main_edge = calculate_edge(ripple_uv);
    vec4 final_color = mix(line_color, bg_color, main_edge);

    ALBEDO = final_color.rgb;
    ALPHA = final_color.a;
}