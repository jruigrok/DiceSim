extends Resource
class_name DiceSetData

@export var behaviours: Array[DiceBehaviour]
@export var material: Material

func handle_on_throw(dice: Dice) -> void:
	for behaviour in behaviours:
		behaviour.on_throw(dice)

func handle_on_roll(dice: Dice, value: int) -> void:
	for behaviour in behaviours:
		behaviour.on_roll(dice, value)

func handle_on_hide(dice: Dice) -> void:
	for behaviour in behaviours:
		behaviour.on_hide(dice)
