extends Resource
class_name DiceSetData

@export var behaviours: Array[DiceBehaviour]
@export var material: Material
@export var physics_material: PhysicsMaterial
@export_multiline var description: String

func handle_on_throw(dice: Dice) -> void:
	for behaviour in behaviours:
		behaviour.on_throw(dice)

func handle_on_pre_roll(dice: Dice) -> int:
	var ret := 0
	for behaviour in behaviours:
		ret = ret + 1 if behaviour.on_pre_roll(dice) else ret
	return ret

func handle_on_roll(dice: Dice, value: int) -> void:
	for behaviour in behaviours:
		behaviour.on_roll(dice, value)

func handle_on_hide(dice: Dice) -> void:
	for behaviour in behaviours:
		behaviour.on_hide(dice)
