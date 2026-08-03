extends Camera3D

@export var sensitivity := 0.002
var pitch := 0.0

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	elif event is InputEventMouseMotion:
		rotate_y(-event.relative.x * sensitivity)

		pitch -= event.relative.y * sensitivity
		pitch = clamp(pitch, -PI/2, PI/2)
		rotation.x = pitch
