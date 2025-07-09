shader_type canvas_item;
uniform sampler2D distortion_texture;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 distortedUV = SCREEN_UV + texture(distortion_texture, UV).r * 0.02;
	vec4 screenColor = texture(TEXTURE, distortedUV);
	COLOR = texture(distortion_texture, UV);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
