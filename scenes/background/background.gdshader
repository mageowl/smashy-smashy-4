shader_type canvas_item;

void fragment() {
	vec2 offset = TIME * vec2(0.3, 0.4);
	COLOR = texture(TEXTURE, UV + offset);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
