shader_type canvas_item;
uniform float pulse_speed = 2.0;

void fragment() {
	vec4 tex = texture(TEXTURE, UV);

	float t = TIME * pulse_speed;

	vec3 colorA = vec3(0.1, 1.0, 0.3); // green
	vec3 colorB = vec3(0.0, 0.8, 1.0); // cyan
	vec3 colorC = vec3(0.6, 0.0, 1.0); // purple

	float blend = sin(t) * 0.5 + 0.5;
	vec3 neon = mix(colorA, colorB, blend);
	neon = mix(neon, colorC, sin(t * 0.5) * 0.5 + 0.5);

	tex.rgb *= neon;

	COLOR = tex;
}