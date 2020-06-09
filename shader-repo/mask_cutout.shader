shader_type canvas_item;

uniform float intensity = 1f;
uniform vec2 position = vec2(0);

void fragment()
{
	vec2 resolution = 1.0 / SCREEN_PIXEL_SIZE;
	
	vec2 current_pixel = SCREEN_UV * resolution;
	vec2 target_pixel = position * resolution;
	float dist = distance(current_pixel, target_pixel);
	
	float radius = intensity * length(resolution) / 2.0;
	
	COLOR.rgb = vec3(1f - clamp(1f + dist - radius, 0f, 1f));
}