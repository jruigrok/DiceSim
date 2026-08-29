extends DiceBehaviour
class_name RandomBh

@export var dice_behaviour_pool: Array[DiceBehaviour]

func on_roll(dice: Dice, value: int) -> void:
	get_rnd_bh().on_roll(dice, value)

func on_throw(dice: Dice) -> void:
	get_rnd_bh().on_throw(dice)

func on_hide(dice: Dice) -> void:
	get_rnd_bh().on_hide(dice)

func get_rnd_bh() -> DiceBehaviour:
	var random_idx := randi_range(0, dice_behaviour_pool.size() - 1)
	return dice_behaviour_pool[random_idx]
