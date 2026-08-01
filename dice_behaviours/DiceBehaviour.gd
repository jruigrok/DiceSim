extends Resource
class_name DiceBehaviour

func on_roll(dice: Dice) -> void:
	print("base on roll called")

func on_free(dice: Dice) -> void:
	print("base on free called")
