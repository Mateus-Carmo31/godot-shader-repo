extends KinematicBody

export(NodePath) var mask_viewport
export(float) var speed = 4.0

var cull_mesh : Spatial

func _ready():
	cull_mesh = $CullMesh
	remove_child(cull_mesh)
	get_node(mask_viewport).add_child(cull_mesh)
	$RemoteTransform.remote_path = cull_mesh.get_path()

var velocity := Vector3.ZERO
func _process(delta):
	
	var forward = - get_viewport().get_camera().global_transform.basis.z.normalized()
	forward.y = 0
	
	var right = get_viewport().get_camera().global_transform.basis.x.normalized()
	right.y = 0
	
	var movement_dir : Vector3
	var hor = (int(Input.is_action_pressed("ui_right")) - 
			   int(Input.is_action_pressed("ui_left")))
	var ver = (int(Input.is_action_pressed("ui_up")) - 
			   int(Input.is_action_pressed("ui_down")))
	
	movement_dir = (forward * ver + right * hor).normalized()
	
	velocity = move_and_slide(movement_dir * speed)

func _physics_process(delta):
	var space_state = get_world().direct_space_state
	
	var result = space_state.intersect_ray(
		global_transform.origin, 
		get_viewport().get_camera().global_transform.origin, 
		[self])
	
	if result:
		$RemoteTransform.scale = lerp($RemoteTransform.scale, Vector3.ONE, 5.0 * delta)
	else:
		$RemoteTransform.scale = lerp($RemoteTransform.scale, Vector3.ZERO, 5.0 * delta)
		
