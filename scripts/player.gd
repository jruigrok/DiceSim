extends Camera3D

@export var sensitivity := 0.002
var pitch := rotation.x

func _unhandled_input(event: InputEvent) -> void:
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED && event is InputEventMouseMotion:
		rotate_y(-event.relative.x * sensitivity)

		pitch -= event.relative.y * sensitivity
		pitch = clamp(pitch, -PI/2, PI/2)
		rotation.x = pitch
