shader_type canvas_item;

uniform vec4 flash_color: source_color = vec4(1.0f);
uniform float flash_percent: hint_range(0.0, 1.0) = 0.0f;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 original_color = texture(TEXTURE, UV);
	
	vec4 mixed_color = mix(original_color, flash_color, flash_percent);
	
	COLOR = mixed_color;
	COLOR.a = original_color.a;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
