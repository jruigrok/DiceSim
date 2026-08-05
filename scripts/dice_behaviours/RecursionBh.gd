extends DiceBehaviour
class_name RecursionBh

@export var sub_dice_set_data: DiceSetData
@export var sub_dice_scale: float = 0.5
@export_flags_3d_physics var sub_dice_col_layer: int = 1 << 1
@export_flags_3d_physics var sub_dice_col_mask: int = 1

func on_roll(dice: Dice, value: int) -> void:
	for i in range(value):
		var sub_dice: Dice = dice.duplicate()
		sub_dice.set_data = sub_dice_set_data
		sub_dice.scale = sub_dice_scale * Vector3.ONE
		sub_dice.collision_layer = sub_dice_col_layer
		sub_dice.collision_mask = sub_dice_col_mask
		dice.get_parent().add_child(sub_dice)
