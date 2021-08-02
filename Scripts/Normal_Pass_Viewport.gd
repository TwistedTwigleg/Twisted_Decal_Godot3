extends Viewport

export (NodePath) var path_to_camera_node;
var camera_node : Camera;
var normal_camera : Camera;

export (ShaderMaterial) var normal_shader_mat;
export (Array, ShaderMaterial) var decal_materials;


func _ready():
	camera_node = get_node(path_to_camera_node);
	normal_camera = get_node("Camera");
	
	size = get_tree().root.size;
	# warning-ignore:return_value_discarded
	get_tree().root.connect("size_changed", self, "on_root_size_changed");
	
	# warning-ignore:return_value_discarded
	get_tree().connect("idle_frame", self, "on_idle_frame");
	
	for shader_mat in decal_materials:
		shader_mat.set_shader_param("world_normal_texture", get_texture());
	
	normal_camera.global_transform = camera_node.global_transform;
	normal_camera.force_update_transform();


func on_idle_frame():
	if (camera_node == null):
		return;
	
	normal_camera.global_transform = camera_node.global_transform;
	normal_camera.force_update_transform();
	
	normal_shader_mat.set_shader_param("normal_camera_mat", normal_camera.global_transform);



func on_root_size_changed():
	size = get_tree().root.size;
