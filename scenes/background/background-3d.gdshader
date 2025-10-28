shader_type spatial;
render_mode unshaded;

uniform vec3 color1 : source_color;
uniform vec3 color2 : source_color;
uniform vec3 color3 : source_color;

void fragment() {
	float xoffset = TIME * 0.4 + (UV.y) * 60.0;
	bool a = mod(UV.x * 12.0 + xoffset, 1.0) > 0.5;
	bool b = mod(UV.y * 100.0 + TIME * 0.3, 1.0) > 0.5;
	
	if (a != b) {
		ALBEDO = color1;
	} else {
		ALBEDO = color2;
	}
	float period = min(UV.y * 2.0, 1.0);
	ALBEDO = ALBEDO + (color3 - ALBEDO) * period;
}
