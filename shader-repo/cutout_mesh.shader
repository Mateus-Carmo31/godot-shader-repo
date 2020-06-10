shader_type spatial;

uniform vec4 albedo : hint_color;
uniform bool interact_with_mask = false;
uniform sampler2D mask;

void fragment()
{
	vec4 mask_check = texture(mask, vec2(SCREEN_UV.x, 1f - SCREEN_UV.y));
	
	bool is_in_mask = mask_check == vec4(1.0);
	
	ALBEDO = albedo.rgb;
	ALPHA = (is_in_mask && interact_with_mask ? 0.0 : 1.0);
}