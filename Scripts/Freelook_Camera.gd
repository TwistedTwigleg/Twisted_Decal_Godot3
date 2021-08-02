extends Spatial

export (float) var mouse_sensitivty = 0.005;

var camera_holder_y : Spatial;
var camera_holder_x : Spatial;
var camera : Camera;

const MOVE_SPEED = 2.0;


func _ready():
	camera_holder_y = self;
	camera_holder_x = get_node("Camera_Holder_X");
	camera = get_node("Camera_Holder_X/Camera");


func _process(delta):
	if (Input.is_action_just_pressed("ui_cancel") == true):
		if (Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE):
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if (Input.is_key_pressed(KEY_W)):
		global_transform.origin += (-camera.global_transform.basis.z.normalized() * delta * MOVE_SPEED);
	if (Input.is_key_pressed(KEY_S)):
		global_transform.origin += (camera.global_transform.basis.z.normalized() * delta * MOVE_SPEED);
	if (Input.is_key_pressed(KEY_A)):
		global_transform.origin += (-camera.global_transform.basis.x.normalized() * delta * MOVE_SPEED);
	if (Input.is_key_pressed(KEY_D)):
		global_transform.origin += (camera.global_transform.basis.x.normalized() * delta * MOVE_SPEED);

func _input(event):
	if (Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED):
		if (event is InputEventMouseMotion):
			camera_holder_x.rotation.x += event.relative.y * mouse_sensitivty;
			camera_holder_y.rotation.y += -event.relative.x * mouse_sensitivty;
