extends MeshInstance3D
class_name DiceRoller

var cur_dice_data: DiceData
var cur_set_data: DiceSetData

var dice_scene = preload("res://dice.tscn")
const MIN_ROLL_VEL = 5
const MAX_ROLL_VEL = 30

func _update_dice(new_dice_data: DiceData, new_set_data: DiceSetData) -> void:
	cur_dice_data = new_dice_data
	cur_set_data = new_set_data
	mesh = cur_dice_data.mesh
	
func roll() -> void:
	if (cur_dice_data == null || cur_set_data == null):
		return
	
	var direction = Vector3(
		randf_range(-1.0, 1.0),
		randf_range(0.5, 1.5),
		randf_range(-1.0, 1.0)
	).normalized()
	
	var init_vel = direction * randf_range(MIN_ROLL_VEL, MAX_ROLL_VEL)
	var init_avel = Vector3((randf() * 10) - 5, (randf() * 10) - 5, (randf() * 10) - 5)
	
	var dice = dice_scene.instantiate()
	dice.dice_data = cur_dice_data
	dice.set_data = cur_set_data
	dice.get_node("MeshInstance3D").mesh = cur_dice_data.mesh
	dice.linear_velocity = init_vel
	dice.angular_velocity = init_avel
	add_child(dice)

func _input(event):
	if event.is_action_pressed("roll_dice"):
		roll()
