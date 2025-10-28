shader_type canvas_item;

uniform float threshold : hint_range(0.0, 1.0, 0.01);
uniform int direction : hint_enum("In", "Out");
uniform vec4 color : source_color;

void fragment() {
	if ((COLOR.r > threshold) != (direction == 1)) {
		COLOR = vec4(0);
	} else {
		COLOR = color;
	}
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
