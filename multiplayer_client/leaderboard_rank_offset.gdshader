shader_type canvas_item;

uniform float y_offset:hint_range(0.0, 50.0, 0.1) = 10;


void vertex() {
	VERTEX += vec2(0, y_offset);
}
