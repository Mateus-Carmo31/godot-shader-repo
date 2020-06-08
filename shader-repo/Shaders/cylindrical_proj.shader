/*
Cylindrical Projection Shader by Garmelon (https://github.com/Garmelon)
Documented by TheWandererBR

https://en.wikipedia.org/wiki/Central_cylindrical_projection
*/

shader_type canvas_item;

// Useful constants :D
const float PI = 3.14159;
const float TAU = 6.28318;
const float HALF_PI = 1.570795;

// This matrix represents the camera's rotation
uniform mat3 rotation;
// Field of View
uniform float fov: hint_range(10, 90) = 90;
// UNUSED
//uniform float cylinder_height = 1;

void fragment() {
	// Calculates the screen resolution
	vec2 resolution = 1.0 / SCREEN_PIXEL_SIZE;
	
	// Obtains the camera's FoV angle (halved) in radians
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
	// You can imagine the y_angle as yaw and the x_axis as pitch.
	float y_angle = atan(towards_pixel.x, towards_pixel.z);
	float x_angle = atan(towards_pixel.y, length(towards_pixel.xz));
	
	/* 
	Finally, find the appropriate UV to sample in the texture.
	It's basically the same as the equirectangular, but with 2 differences:
	
	1. We use mod for the x axis. It is another way of making the x values fit the
	appropriate range.
	
	2. Instead of just using the x_angle, we actually add the length the angle
	covers on the y axis (which is the tangent of the angle). This is all part
	of the projection math, and it's quite hard to visualize, so don't feel
	pressured to do so.
	*/
	vec2 coords;
	coords.x = mod(y_angle, TAU) / TAU;
	coords.y = (tan(x_angle) + HALF_PI) / PI;
	
	// Samples the texture.
	/*
	Note that this kind of projection screws up the poles (due to the fact that
	it's basically a cylinder). What we do here is cover the ugly mapping on the
	poles (ie. area not in the [0,1] range) with a simple checkerboard pattern.
	*/
	if (coords.y >= 0.0 && coords.y <= 1.0) {
		COLOR = texture(TEXTURE, coords);
	} else {
		vec2 screen_pos = SCREEN_UV * resolution;
		vec2 square = floor(screen_pos / 12.0);
		if (mod(square.x + square.y, 2.0) > 0.5) {
			COLOR.rgb = vec3(0.3)
		} else {
			COLOR.rgb = vec3(0.4);
		}
	}
}
