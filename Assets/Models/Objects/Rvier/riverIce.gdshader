shader_type spatial;
render_mode unshaded;
uniform sampler2D colorTexture : filter_nearest_mipmap;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	ALBEDO = texture(colorTexture, UV + vec2(sin(TIME)/70.0, TIME/50.0)).rgb;
	// Called for every pixel the material is visible on.
}

void light() {
	// Called for every pixel for every light affecting the CanvasItem.
}
