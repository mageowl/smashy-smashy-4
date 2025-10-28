shader_type particles;

// CUSTOM = (lifetime, max_scale, _, _)

void start() {
	CUSTOM.x = 1.0;
	CUSTOM.y = 16.0;
	
	if (RESTART_POSITION) {
		TRANSFORM[3].xyz = vec3(0);
	}
}

void process() {
	CUSTOM.x -= DELTA / LIFETIME;
	
	float scale = CUSTOM.x * CUSTOM.y;
	TRANSFORM[0].xyz = vec3(scale, 0.0, 0.0);
	TRANSFORM[1].xyz = vec3(0.0, scale, 0.0);
	TRANSFORM[2].xyz = vec3(0.0, 0.0, scale);
	
	if (CUSTOM.x <= 0.0) {
		ACTIVE = false;
	}
}
