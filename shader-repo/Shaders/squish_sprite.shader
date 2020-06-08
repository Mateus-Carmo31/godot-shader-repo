/*
Squish Sprite Shader by Garmelon (https://github.com/Garmelon)
Documented by TheWandererBR
*/

shader_type canvas_item;

uniform bool uv_mode = false;
uniform float x_factor = 2.0;
uniform float bulge : hint_range(-1,1);

void vertex()
{
	// Stretches the sprite along the x axis by the x_factor.
	// This essentially increases the bounds in which the sprite can be drawn,
	// allowing the sprite to bulge outwards appropriately.
	VERTEX.x *= x_factor;
}

// Describes how the sprite bulges. Right now, it's a simple half-circle function.
// Changing it modifies how the bulges will look like.
// Must be a function in which the x will be between 0 and 1 for y between -1 and 1.
float bulge_function(float y)
{
	return sqrt(1.0 - y * y);
}

void fragment()
{
	// Remaps the UV (normally from 0.0 to 1.0) to go from -1.0 to 1.0
	vec2 uv = UV * 2.0 - 1.0;
	
	// Counteracts the vertex stretch by increasing the uv by the same factor
	// (Since textures are mapped from 0 to 1, multiplying the UV will make
	// it go from 0 to something else, and the texture will remain between 0 and 1.
	// this results in it becoming smaller)
	uv.x *= x_factor;
	
	/* The main meat of the shader.
	Calculates a displacement using the bulge factor and the function,
	then divides the x by it. 
	
	If the displacement is positive, the UV values will be brought back 
	towards 0, and the texture will be sampled at inner values (essentially 
	stretching the texture outwards). The opposite will happen if the 
	displacement is negative, with the UV values being pushed outwards, and the 
	texture being sampled at outer values.
	
	This also has the bonus of causing certain pixels to sample values < 0 or > 1,
	which will be caught by the if statement below and be rendered transparent.
	
	Remember as well that the x factor causes the UV to go from -2 to 2 on the x
	axis.
	*/
	float displacement = 1.0 + bulge * bulge_function(uv.y);
	uv.x /= displacement;
	
	// Undoes the remapping we did at the beginning
	uv = (uv + 1.0) / 2.0;
	
	// Draws the uv instead of the texture (for debugging)
	if(uv_mode)
	{
		COLOR = vec4(uv, 0.0, 1.0);
	}
	// Checks for uv values outside the texture, and draws them as transparent,
	// allowing the "indentation" effect when bulge < 0
	else if(uv.x >= 0.0 && uv.x <= 1.0)
	{
		COLOR = texture(TEXTURE, uv);
	}
	else
	{
		COLOR = vec4(0.0);
	}
}