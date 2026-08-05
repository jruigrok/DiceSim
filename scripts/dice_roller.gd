extends MeshInstance3D
class_name DiceRoller

var cur_dice_data: DiceData
var cur_set_data: DiceSetData

var dice_scene: PackedScene = preload("res://scenes/dice.tscn")
@onready var dice_selector: DiceSelector = get_parent().get_node("DiceSelector")


const MIN_ROLL_VEL = 5
const MAX_ROLL_VEL = 10

const MAX_CHARGE := 1.5
const MIN_SPEED := 5.0
const MAX_SPEED := 30.0
const LOBB_ANGLE := 15.0
var charging := false
var time_charging: float = 0
var throw_ready := false

func _process(delta: float) -> void:
	if charging:
		time_charging = min(time_charging + delta, MAX_CHARGE)
		dice_selector.power_bar.value = (time_charging / MAX_CHARGE) * 100

func _update_dice(new_dice_data: DiceData, new_set_data: DiceSetData) -> void:
	throw_ready = true
	cur_dice_data = new_dice_data
	cur_set_data = new_set_data
	mesh = cur_dice_data.mesh
	material_override = cur_set_data.material

func throw_dice() -> void:
	var speed: float = lerp(MIN_SPEED, MAX_SPEED, time_charging / MAX_CHARGE)
	var camera: Camera3D = get_viewport().get_camera_3d()
	var forward: Vector3 = -camera.global_basis.z
	var direction: Vector3 = forward.rotated(camera.global_basis.x, deg_to_rad(LOBB_ANGLE))
	direction = direction.normalized()
	
	var dice: Dice = dice_scene.instantiate()
	dice.dice_data = cur_dice_data
	dice.set_data = cur_set_data
	dice.linear_velocity = direction * speed
	dice.angular_velocity = Vector3(
		randf_range(-10, 10),
		randf_range(-10, 10),
		randf_range(-10, 10)
	)
	get_tree().current_scene.add_child(dice)
	dice.position = get_parent().global_position + (Vector3.DOWN * 3)
	dice_selector.power_bar.value = 0

func _unhandled_input(event: InputEvent) -> void:
	if throw_ready:
		if event.is_action_pressed("throw_dice"):
			charging = true
			time_charging = 0
		elif event.is_action_released("throw_dice"):
			charging = false
			throw_dice()
