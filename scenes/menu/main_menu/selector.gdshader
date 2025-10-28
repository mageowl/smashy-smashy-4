shader_type canvas_item;

uniform vec2 offset;

void fragment() {
	vec2 uv = UV - offset * TEXTURE_PIXEL_SIZE;
	
	if (uv.x <= 1.0 && uv.y <= 1.0 && uv.x >= 0.0 && uv.y >= 0.0) {
		COLOR = texture(TEXTURE, uv);
	} else {
		COLOR = vec4(0);
	}
}
