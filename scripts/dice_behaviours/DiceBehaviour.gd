@abstract
class_name DiceBehaviour
extends Resource

func on_pre_roll(_dice: Dice) -> bool:
	return false
func on_roll(_dice: Dice, _value: int) -> void:
	pass
func on_hide(_dice: Dice) -> void:
	pass
func on_throw(_dice: Dice) -> void:
	pass
