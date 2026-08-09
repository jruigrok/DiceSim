extends DiceBehaviour
class_name RecursionBh

@export var sub_dice_set_data: DiceSetData
@export var sub_dice_scale: float = 0.5
@export_flags_3d_physics var sub_dice_col_layer: int = 1 << 1
@export_flags_3d_physics var sub_dice_col_mask: int = 1
var dice_scene: PackedScene = preload("res://scenes/dice.tscn")

func on_roll(dice: Dice, value: int) -> void:
	for i in range(value):
		var sub_dice: Dice = dice_scene.instantiate()
		sub_dice.dice_data = dice.dice_data
		sub_dice.set_data = sub_dice_set_data
		dice.get_parent().add_child(sub_dice)
		sub_dice.global_position = dice.global_position
		sub_dice.scale = sub_dice_scale * Vector3.ONE
		sub_dice.collision_layer = sub_dice_col_layer
		sub_dice.collision_mask = sub_dice_col_mask
