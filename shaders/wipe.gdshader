shader_type canvas_item;

uniform sampler2D MASK;

void fragment() {
	COLOR = texture(TEXTURE, UV);
	COLOR.a *= texture(MASK, UV).x;
}