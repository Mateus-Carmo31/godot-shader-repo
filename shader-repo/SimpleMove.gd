extends MeshInstance

export(NodePath) var mask_viewport
export(float) var speed = 4.0

func _ready():
	var cull_mesh = $CullMesh
	remove_child(cull_mesh)
	get_node(mask_viewport).add_child(cull_mesh)
	$RemoteTransform.remote_path = cull_mesh.get_path()

func _process(delta):
	
	var forward = - get_viewport().get_camera().global_transform.basis.z
	forward.y = 0
	
	var right = get_viewport().get_camera().global_transform.basis.x
	right.y = 0
	
	var movement_dir : Vector3
	var hor = (int(Input.is_action_pressed("ui_right")) - 
			   int(Input.is_action_pressed("ui_left")))
	var ver = (int(Input.is_action_pressed("ui_up")) - 
			   int(Input.is_action_pressed("ui_down")))
	
	movement_dir = (forward * ver + right * hor).normalized()
	
	translation += movement_dir * delta * speed
	
#	update_mask_position()
#
#func update_mask_position():
#
#	var screen_pos = get_viewport().get_camera().unproject_position(translation)
#	screen_pos = Vector2(screen_pos.x, screen_pos.y) / get_viewport().size
#
#	if mask_texture:
#		var node = get_node(mask_texture)
#		node.material.set("shader_param/position", screen_pos)
