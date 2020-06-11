/*
PSX Fadeout Shader by TheWandererBR

A simple fade-to-black inspired by original PSX games
*/

shader_type canvas_item;

// The intensity of the fade, with 0 being none and 1 being completely faded
uniform float intensity : hint_range(0, 1);

void fragment()
{
	// Samples the screen
	vec3 color = texture(SCREEN_TEXTURE, SCREEN_UV).rgb;
	
	// Simple subtraction. Will make it so lighter areas take longer to fade out
	// than dimly lit ones
	color -= vec3(intensity);
	
	// A simple color clamp to avoid negative colors (although I believe OpenGL
	// already forbids negative colors by default)
	COLOR.rgb = clamp(color, 0.0, 1.0);
}