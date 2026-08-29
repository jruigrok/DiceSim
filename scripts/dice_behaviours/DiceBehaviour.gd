@abstract
class_name DiceBehaviour
extends Resource

enum Event {
	ON_HIDE,
	ON_THROW,
	ON_ROLL,
	ON_TOUCH
}

func on_pre_roll(_dice: Dice) -> bool:
	return false
func on_roll(_dice: Dice, _value: int) -> void:
	pass
func on_hide(_dice: Dice) -> void:
	pass
func on_throw(_dice: Dice) -> void:
	pass
