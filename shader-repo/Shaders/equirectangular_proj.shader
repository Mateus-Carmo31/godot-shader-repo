shader_type canvas_item;

const float PI = 3.14159;
const float TAU = PI * 2.0;
const float HALF_PI = PI / 2.0;

uniform mat3 rotation;
uniform float fov: hint_range(10, 90) = 90;

void fragment() {
	vec2 resolution = 1.0 / SCREEN_PIXEL_SIZE;
	
	float theta = (PI / 180.0) * (fov / 2.0);
	vec2 pixel = (SCREEN_UV * 2.0 - 1.0) * tan(theta);
	pixel.y *= - resolution.y / resolution.x;
	// Assuming depth of 1
	vec3 towards_pixel = rotation * vec3(pixel, -1);
	
	float y_angle = atan(towards_pixel.x, towards_pixel.z);
	float x_angle = atan(towards_pixel.y, length(towards_pixel.xz));
	
	vec2 coords;
	coords.x = mod(y_angle, TAU) / TAU;
	coords.y = (x_angle + HALF_PI) / PI;
	
	COLOR = texture(TEXTURE, coords);
}
