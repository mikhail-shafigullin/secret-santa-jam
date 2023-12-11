shader_type spatial;
render_mode unshaded, cull_disabled, fog_disabled;
uniform sampler2D color : source_color,filter_nearest,repeat_enable;
uniform float speed : hint_range(0.0, 10.0, 0.1);

void vertex() {
	float id = NODE_POSITION_WORLD.x - NODE_POSITION_WORLD.z;
	UV = vec2(UV.x - float(int(mod((TIME+id)*speed, 32.0))) / 32.0, UV.y);
	// Called for every vertex the material is visible on.
}

void fragment() {
	ALBEDO = texture(color, UV).rgb;
	// Called for every pixel the material is visible on.
}

void light() {
	// Called for every pixel for every light affecting the material.
}
