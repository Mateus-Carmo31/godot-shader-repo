extends Spatial

export(float) var turn_speed = 5.0
var target_angle : float = deg2rad(-45)

func _process(delta):
	
	rotation.y = lerp_angle(rotation.y, target_angle, delta * turn_speed)
	
	if Input.is_action_just_pressed("turn_left"):
		target_angle -= PI/2
		target_angle = wrapf(target_angle, -PI, PI)
		print(rad2deg(target_angle))
	elif Input.is_action_just_pressed("turn_right"):
		target_angle += PI/2
		target_angle = wrapf(target_angle, -PI, PI)
		print(rad2deg(target_angle))

