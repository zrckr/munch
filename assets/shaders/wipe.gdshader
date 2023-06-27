shader_type canvas_item;

uniform float percentage: hint_range(0, 1, 0.01);
uniform float masked_alpha: hint_range(0, 1, 0.01) = 1;
uniform float unmasked_alpha: hint_range(0, 1, 0.01);

uniform bool horizontal = false;
uniform bool invert = true;

void fragment() {
	float uv_position = UV.y;
	if (horizontal) {
		uv_position = UV.x;
	}
	
	float amount = 1.0 - percentage;
	float step_value = unmasked_alpha + step(uv_position, amount);
	
	if (invert) {
		step_value = unmasked_alpha + 1.0 - step(uv_position, amount);
	}
	
	vec4 main_texture = texture(TEXTURE, UV);
	COLOR.a = main_texture.a * step_value * masked_alpha;
}