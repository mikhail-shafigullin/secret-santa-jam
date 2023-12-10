shader_type spatial;
render_mode unshaded, cull_back, fog_disabled;
uniform sampler2D color : source_color,filter_nearest,repeat_enable;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	ALBEDO = texture(color, UV).rgb;
	ALPHA = texture(color, UV).a;
	// Called for every pixel the material is visible on.
}

void light() {
	// Called for every pixel for every light affecting the material.
}
