extends Resource
class_name DiceSetData

@export var behaviours: Array[DiceBehaviour]
@export var material: Material

func handle_behaviours(function_name: StringName, dice: Dice) -> void:
	for behaviour in behaviours:
		if behaviour.has_method(function_name):
			behaviour.call(function_name, dice)
		else:
			push_error("No behaviour function %s", function_name)
