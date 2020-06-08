extends TextureRect

export var sensitivity: Vector3 = Vector3(0.005, 0.005, TAU/4)
var euler: Vector3 = Vector3.ZERO

func _init() -> void:
	sensitivity.x *= -1

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	if event is InputEventKey and event.scancode == KEY_R and event.pressed:
		euler.z = 0

	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			euler.x += event.relative.y * sensitivity.y
			euler.x = clamp(euler.x, -TAU/4, TAU/4)
			euler.y += event.relative.x * sensitivity.x
			euler.y = fmod(euler.y, TAU)

func _process(delta: float) -> void:
	if Input.is_key_pressed(KEY_Q):
		euler.z -= delta * sensitivity.z
	if Input.is_key_pressed(KEY_E):
		euler.z += delta * sensitivity.z
	euler.z = clamp(euler.z, -TAU/4, TAU/4)

	material.set_shader_param("rotation", Basis(euler))
