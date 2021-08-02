shader_type spatial;

// Unshaded - use this code!
// Also disable vertex code and normal mapping code!
//render_mode unshaded, cull_disabled, depth_test_disable;

render_mode cull_disabled;

uniform vec4 albedo : hint_color;
uniform sampler2D texture_albedo : hint_albedo;
uniform bool clip_based_on_angle = false;

uniform bool use_normals = false;
uniform sampler2D texture_normal : hint_normal;
uniform float normal_map_strength = 1.0;

uniform float cube_half_size = 1.0;

uniform sampler2D world_normal_texture : hint_albedo;
uniform vec3 decal_normal_vector = vec3(0.0, 1.0, 0.0);
uniform float decal_normal_vector_angle_tolerance = 0.5;

varying mat4 inverse_world_mat;


// Credit: https://stackoverflow.com/questions/32227283/getting-world-position-from-depth-buffer-value
vec3 world_pos_from_depth(float depth, vec2 screen_uv, mat4 inverse_proj, mat4 inverse_view) {
	float z = depth * 2.0 - 1.0;
	
	vec4 clipSpacePosition = vec4(screen_uv * 2.0 - 1.0, z, 1.0);
	vec4 viewSpacePosition = inverse_proj * clipSpacePosition;
	
	viewSpacePosition /= viewSpacePosition.w;
	
	vec4 worldSpacePosition = inverse_view * viewSpacePosition;
	
	return worldSpacePosition.xyz;
}

void vertex() {
	NORMAL = vec3(0, 0, 0.0);
	TANGENT = vec3(0, 0.0, 0);
	BINORMAL = vec3(0.0, 0, 0);
	
	inverse_world_mat = inverse(WORLD_MATRIX);
}

void fragment() {
	
	// ============================================
	// DRAW THE DECAL OVER WORLD GEOMETRY
	float depth = texture(DEPTH_TEXTURE, SCREEN_UV).x;
	vec3 world_pos = world_pos_from_depth(depth, SCREEN_UV, INV_PROJECTION_MATRIX, (CAMERA_MATRIX));
	vec4 test_pos = (inverse_world_mat * vec4(world_pos, 1.0));
	
	if (abs(test_pos.x) > cube_half_size || abs(test_pos.y) > cube_half_size || abs(test_pos.z) > cube_half_size) {
		discard;
	}
	vec4 texture_albedo_color = texture(texture_albedo, (test_pos.xz * 0.5) + 0.5);
	ALBEDO = texture_albedo_color.rgb * albedo.rgb;
	ALPHA = texture_albedo_color.a * albedo.a;
	// ============================================
	
	// CLIP BASED ON NORMAL ANGLE FROM VIEWPORT
	// ============================================
	if (clip_based_on_angle == true) {
		vec2 UV_to_use = SCREEN_UV;
		UV_to_use.y = 1.0 - UV_to_use.y;
		vec4 world_normal = texture(world_normal_texture, UV_to_use);
		
		float normal_dot = acos(clamp(dot(world_normal.xyz, decal_normal_vector), 0.0, 1.0));
		if (normal_dot > decal_normal_vector_angle_tolerance) {
			discard;
		}
		// To visualize dot results, uncomment line:
		//ALBEDO = vec3(normal_dot);
		// To visualize world normal, uncomment line:
		//ALBEDO = world_normal.xyz;
	}
	// ============================================
	
	
	// ============================================
	// CALCULATE THE NORMAL (for lighting) from depth
	if (use_normals == true) {
		world_pos = (INV_CAMERA_MATRIX * vec4(world_pos, 1.0)).xyz;
		vec3 normal = normalize(cross(dFdx(world_pos.xyz), dFdy(world_pos.xyz)));
		NORMAL = normal;
		NORMALMAP = texture(texture_normal, (test_pos.xz * 0.5) + 0.5).rgb;
		NORMALMAP_DEPTH = normal_map_strength;
		
		// Source: (user464230)
		// URL: https://stackoverflow.com/questions/5255806/how-to-calculate-tangent-and-binormal
		vec3 c1 = cross(normal, vec3(0.0, 0.0, 1.0));
		vec3 c2 = cross(normal, vec3(0.0, -1.0, 0.0));
		if (length(c1) > length(c2)) {
			TANGENT = c1;
		} else {
			TANGENT = c2;
		}
		TANGENT = normalize(TANGENT);
		BINORMAL = normalize(cross(normal, TANGENT));
	}
	else
	{
		NORMAL = vec3(0, 0, 1);
		TANGENT = vec3(0, 1, 0);
		BINORMAL = vec3(1, 0, 0);
	}
	// ============================================
}