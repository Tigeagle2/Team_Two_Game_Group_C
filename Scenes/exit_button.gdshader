shader_type canvas_item;

uniform float pulse_speed = 2.0;
uniform float pulse_strength = 0.3;
uniform float hover_intensity = 1.0;

void fragment() {
    vec4 tex = texture(TEXTURE, UV);
    if (tex.a < 0.1) discard;

    float t = TIME * pulse_speed; // hue shift independent of hover

    vec3 colorA = vec3(0.1, 1.0, 0.3);
    vec3 colorB = vec3(0.0, 0.8, 1.0);
    vec3 colorC = vec3(0.6, 0.0, 1.0);

    float blend = sin(t) * 0.5 + 0.5;
    vec3 neon = mix(colorA, colorB, blend);
    neon = mix(neon, colorC, sin(t * 0.5) * 0.5 + 0.5);

    float pulse = (sin(TIME * pulse_speed) * 0.5 + 0.5) * pulse_strength + 1.0;

    vec3 final_color = tex.rgb * neon * pulse * hover_intensity;

    final_color = clamp(final_color, 0.0, 1.0);

    COLOR = vec4(final_color, tex.a);
}