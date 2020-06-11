shader_type spatial;

// Color of the object.
uniform vec4 albedo : hint_color;
// Should this mesh care about the mask?
uniform bool interact_with_mask = false;
// ViewportTexture from the StencilViewport
uniform sampler2D mask;

void fragment()
{
	// Samples the mask texture.
	vec4 mask_check = texture(mask, vec2(SCREEN_UV.x, SCREEN_UV.y));
	
	// If the pixel's position on the screen would be inside the mask, this is true.
	bool is_in_mask = mask_check == vec4(1.0);
	
	// We set the color for every pixel, and draw the pixel as transparent (ALPHA == 0)
	// if it is inside the mask and interact_with_mask is true.
	ALBEDO = albedo.rgb;
	ALPHA = (is_in_mask && interact_with_mask ? 0.0 : 1.0);
}