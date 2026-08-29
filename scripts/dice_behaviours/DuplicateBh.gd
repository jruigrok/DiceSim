extends DiceBehaviour
class_name DuplicateBh

@export var sub_dice_set_data: DiceSetData
@export var num_duplicates: int = 7

func on_throw(dice: Dice) -> void:
	for i in range(num_duplicates):
		var new_dice := Dice.new_dice(dice.dice_data, sub_dice_set_data)
		dice.get_parent().add_child(new_dice)
		new_dice.global_position = dice.global_position
		new_dice.linear_velocity = dice.linear_velocity
