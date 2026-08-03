extends DiceBehaviour
class_name ExplosionBh

@export var explosion_effect_sc: PackedScene

func on_hide(dice: Dice) -> void:
	var explosion_effect: VFXControllerBB = explosion_effect_sc.instantiate()
	dice.add_child(explosion_effect)
	explosion_effect.play()
