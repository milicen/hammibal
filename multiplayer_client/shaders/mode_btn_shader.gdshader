shader_type canvas_item;

uniform float vertex_offset = 0.0;


void vertex() {
	VERTEX += vec2(0.0, vertex_offset);
}