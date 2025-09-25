shader_type canvas_item;

uniform vec3 color: source_color = vec3(1);
uniform float amount: hint_range(0.0, 1.0, 0.1) = 0.0;

void fragment() {
	COLOR = mix(COLOR, vec4(color, COLOR.a), amount);
}
