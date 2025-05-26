shader_type canvas_item;

//====== НАСТРОЙКИ ======//
uniform float scale : hint_range(0.1, 5.0) = 1.0;
uniform vec4 color1 = vec4(0.1, 0.62, 0.67, 1.0);
uniform vec4 color2 = vec4(0.67, 0.67, 0.5, 1.0);
uniform float animation_speed : hint_range(0.0, 1.0) = 2.15;

//====== УЛУЧШЕННАЯ ГЕНЕРАЦИЯ ШУМА ======//
float random(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898, 78.233))) * 43758.5453123);
}

// Более гладкий шум с квинтической интерполяцией
float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));
    
    // Квинтическая интерполяция для большей гладкости
    vec2 u = f * f * f * (f * (f * 6.0 - 15.0) + 10.0);
    return mix(a, b, u.x) + 
           (c - a) * u.y * (1.0 - u.x) + 
           (d - b) * u.x * u.y;
}

#define NUM_OCTAVES 5
float fbm(vec2 st) {
    float v = 0.0;
    float a = 0.5;
    float freq = 1.8; // Уменьшенный коэффициент масштабирования
    vec2 shift = vec2(50.0); // Меньшее смещение
    
   mat2 rot = mat2(
    vec2(cos(0.5), sin(0.5)),  // Явное создание vec2 для первой строки
    vec2(-sin(0.5), cos(0.5))  // Явное создание vec2 для второй строки
);
    
    for(int i = 0; i < NUM_OCTAVES; i++) {
        v += a * noise(st);
        st = rot * st * freq + shift;
        a *= 0.55; // Медленнее уменьшаем амплитуду
    }
    return v / 0.8; // Нормализация
}

//====== ОСНОВНОЙ ФРАГМЕНТ С ГЛАДКИМ СМЕШИВАНИЕМ ======//
void fragment() {
    vec2 st = UV * scale;
    
    // Плавные деформации с меньшей интенсивностью
    vec2 q = vec2(
        fbm(st + TIME * animation_speed * 0.3),
        fbm(st + vec2(0.7, 0.3))
    );
    
    vec2 r = vec2(
        fbm(st + 0.6*q + vec2(1.2, 4.5) + TIME * animation_speed * 0.2),
        fbm(st + 0.6*q + vec2(3.1, 2.6) + TIME * animation_speed * 0.3)
    );
    
    // Финальный шум с плавными переходами
    float f = fbm(st + 0.8*r);
    
    // Мягкое смешивание цветов
    vec3 color = mix(color1.rgb, color2.rgb, smoothstep(0.2, 0.8, f));
    color = mix(color, vec3(0.0, 0.0, 0.16), smoothstep(0.3, 0.9, length(q)));
    color = mix(color, vec3(0.67, 1.0, 1.0), smoothstep(0.4, 1.0, length(r.x)));
    
    // Плавное усиление контраста
    float contrast = smoothstep(0.3, 0.7, f);
    COLOR = vec4(mix(vec3(0.9), color, contrast * 1.2), 1.0);
}