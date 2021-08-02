shader_type spatial;
render_mode unshaded;

void fragment() {
	vec3 normal_vec = NORMAL;
	normal_vec = mat3(CAMERA_MATRIX) * normal_vec;
	ALBEDO = normal_vec;
}