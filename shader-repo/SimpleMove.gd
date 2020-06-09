extends MeshInstance

export(NodePath) var mask_texture
export(float) var speed = 4.0

func _ready():
	pass # Replace with function body.

func _process(delta):
	
	var forward = - get_viewport().get_camera().transform.basis.z
	forward.y = 0
	
	var right = get_viewport().get_camera().transform.basis.x
	right.y = 0
	
	var movement_dir : Vector3
	var hor = (int(Input.is_action_pressed("ui_right")) - 
			   int(Input.is_action_pressed("ui_left")))
	var ver = (int(Input.is_action_pressed("ui_up")) - 
			   int(Input.is_action_pressed("ui_down")))
	
	movement_dir = (forward * ver + right * hor).normalized()
	
	translation += movement_dir * delta * speed
	
	update_mask_position()

func update_mask_position():
	
	var screen_pos = get_viewport().get_camera().unproject_position(translation)
	screen_pos = Vector2(screen_pos.x, screen_pos.y) / get_viewport().size
	
	if mask_texture:
		var node = get_node(mask_texture)
		node.material.set("shader_param/position", screen_pos)
