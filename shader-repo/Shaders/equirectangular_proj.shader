/*
Equirectangular Projection Shader by Garmelon (https://github.com/Garmelon)
Documented by TheWandererBR

https://wiki.panotools.org/Equirectangular_Projection
https://en.wikipedia.org/wiki/Equirectangular_projection
*/

shader_type canvas_item;

// Useful constants :D
const float PI = 3.14159;
const float TAU = 6.28318;
const float HALF_PI = 1.570795;

// Debug view
uniform bool uv_view = false;
// This 3x3 matrix represents the current camera angle
uniform mat3 rotation;
// Camera's field of view
uniform float fov: hint_range(10, 90) = 90;

void fragment() {
	// Define the resolution
	vec2 resolution = 1.0 / SCREEN_PIXEL_SIZE;
	
	// Our theta (angle) will be half of the FoV converted to radians
	float theta = (PI / 180.0) * (fov / 2.0);
	
	/* 
	The math here is a tad tricky, so bear with me.
	Here, we assume that the distance from the image to the viewpoint is 1.
	That way, to draw the texture in front of the camera, we scale the screen UV
	to go from -1 to 1, and then scale this range to be relative to how wide
	the camera angle is (which is the tangent of theta). There is a sketch in
	the assets folder that illustrates this.
	*/
	vec2 pixel = (SCREEN_UV * 2.0 - 1.0) * tan(theta);
	
	// Apply the aspect ratio. Since screen UV goes from bottom left to top right
	// (as opposed to top left to bottom right), we need to invert it as well.
	pixel.y *= - resolution.y / resolution.x;
	
	// Assuming depth of 1, we define where exactly this part of the UV would
	// map in world space. Basically where we would need to "point towards"
	// from the camera to reach it in the texture.
	vec3 towards_pixel = rotation * vec3(pixel, -1);
	
	// Obtain the angles (in radians) on the y and x axis of the vector that points 
	// towards the pixel. We use the vector towards_pixel.xz for the x angle 
	// because we know there is a rotation on the y axis, so that vector is better 
	// for measuring the x rotation.
	// You can consider the y_angle as yaw and x_axis as pitch.
	float y_axis_angle = atan(towards_pixel.x, towards_pixel.z);
	float x_axis_angle = atan(towards_pixel.y, length(towards_pixel.xz));
	
	// Finally find the appropriate UV to sample in the texture.
	// The x axis is a full 360 rotation, so we use TAU (PI * 2).
	// The y axis is 180 degrees, so we USE PI.
	// We also add PI and HALF_PI to the angles, so that they go from [-180, 180]
	// and [-90, 90] to [0, 360] and [0, 180], respectively.
	//
	// SIDENOTE: If the texture is set to REPEAT, adding the PI is not necessary
	// on the x. This is because the UV will be sampled on the other side of the
	// texture and correct itself (as if looping around a circle)
	vec2 coords;
	coords.x = (y_axis_angle + PI) / TAU;
	coords.y = (x_axis_angle + HALF_PI) / PI;
	
	if(!uv_view)
		COLOR = texture(TEXTURE, coords);
	else
		COLOR = vec4(coords, 0.0, 1.0);
}
