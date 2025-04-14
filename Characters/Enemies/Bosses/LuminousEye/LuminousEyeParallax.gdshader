shader_type canvas_item;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_nearest;
uniform sampler2D distortion_texture;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 distortedUV = SCREEN_UV + texture(distortion_texture, SCREEN_UV).r * 0.05;
	vec4 screenColor = texture(SCREEN_TEXTURE, distortedUV);
	COLOR = screenColor;
	//COLOR = vec4(TIME*(UV.y - 0.01));
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
