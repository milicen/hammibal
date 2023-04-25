shader_type canvas_item;

uniform vec4 hue : source_color;

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	color.rgb = hue.rgb;
	COLOR = color;
}
