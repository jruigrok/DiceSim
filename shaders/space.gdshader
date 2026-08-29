shader_type spatial;

uniform sampler2D space_texture;
uniform float speed = 0.02;

void vertex() {
}

void fragment() {
	vec2 offset = vec2(TIME * speed, TIME * speed);
	vec2 uv = UV + offset;
	vec3 color = texture(space_texture, uv).rgb;
	
	color = (color - 0.2) * 1.2 + 0.2;
	
	ALBEDO = color;
	ROUGHNESS = 1.0;
}
