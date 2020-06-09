extends Spatial

export(NodePath) var target

func _process(delta):
	
	if target:
		translation = get_node(target).translation
