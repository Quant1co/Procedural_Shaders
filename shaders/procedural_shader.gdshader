shader_type canvas_item;

void fragment() {
    // Масштабируем координаты для увеличения размера ячеек
    float scale = 60.0; // Увеличиваем масштаб в 20 раз
    vec2 uv = FRAGCOORD.xy / scale;

    // Процедурная генерация: создаем шахматный узор
    float checker = mod(floor(uv.x) + floor(uv.y), 2.0);

    // Используем шахматный узор для создания цвета
    COLOR = vec4(checker, checker, checker, 1.0);
}