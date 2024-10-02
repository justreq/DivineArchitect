shader_type canvas_item;

uniform sampler2D screenTexture: hint_screen_texture;
uniform sampler2D noiseTexture: filter_nearest, repeat_enable;

uniform vec2 speed = vec2(0.5, 0.5);
uniform float strength = 0.1;
uniform float distortion = 0.01;

void vertex() {
	// VERTEX.y += sin(TIME);
}

void fragment() {
	vec2 noise = 2.0 * texture(noiseTexture, UV + speed * TIME).rg - vec2(1.0);
	
	COLOR = texture(TEXTURE, UV + noise * strength);
	COLOR *= texture(screenTexture, SCREEN_UV + noise * distortion);
}