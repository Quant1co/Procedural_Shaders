shader_type canvas_item;

// Настройки
uniform int vertices : hint_range(3, 16) = 4;       // Количество вершин/лепестков
uniform float scale : hint_range(0.1, 10.0) = 3.0; // Масштаб узора
uniform float iterations : hint_range(1, 10) = 1;   // Глубина фрактала
uniform float speed : hint_range(0.0, 2.0) = 1.0;  // Скорость анимации
uniform vec3 color1 = vec3(0.8, 0.2, 0.4); // Цвет 1
uniform vec3 color2 = vec3(0.2, 0.5, 0.8); // Цвет 2

void fragment() {
    vec2 uv = UV - 0.5;

    float angle = atan(uv.y, uv.x);
    float radius = length(uv) * scale;

    angle += TIME * speed;

    float pattern = 0.8;
    for (float i = 0.0; i < iterations; i++) {
        // Нормализуем угол перед вычислением косинуса
        angle = mod(angle, 6.28318530718); // Эквивалент 2π
        pattern += cos(angle * float(vertices) + i * 3.0) * 0.5 + 0.5;

        angle *= 1.5;
        radius *= 1.2;

        // Дополнительная нормализация для отрицательных углов
        angle = mod(angle + 3.14159265359, 6.28318530718) - 3.14159265359;
    }

    pattern /= iterations;
    vec3 color = mix(color1, color2, pattern);

    // Исправляем дублированное присваивание COLOR
    COLOR = vec4(color, 1.0);
}