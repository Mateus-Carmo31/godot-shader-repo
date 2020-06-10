/*
PSX Fadeout Shader by TheWandererBR
(pending docs)
*/


shader_type canvas_item;

uniform float intensity : hint_range(0, 1);

void fragment()
{
	vec3 color = texture(SCREEN_TEXTURE, SCREEN_UV).rgb;
	color -= vec3(intensity);
	COLOR.rgb = color;
}