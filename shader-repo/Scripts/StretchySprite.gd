tool
extends Sprite

export(bool) var active = true
export(float) var stretch_effect = 1.0

func _process(delta):
	
	if Input.is_key_pressed(KEY_UP):
		scale.y += delta
	
	if active:
		material.set("shader_param/bulge",
			clamp(1.0 - scale.y * stretch_effect, -1.0, 1.0))
