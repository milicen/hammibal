shader_type canvas_item;

uniform float percentage : hint_range(0.0, 1.0, 0.1) = 0.0;

void fragment() {
	// Place fragment code here.
	vec4 main_tx = texture(TEXTURE, UV);
	float avg = (main_tx.r + main_tx.g + main_tx.b) / 3.0;
	COLOR.a = main_tx.a;
	COLOR.rgb = mix(main_tx.rgb, vec3(avg), percentage);
}
