extends DiceBehaviour
class_name SpawnParticlesBh

var particles: PackedScene = preload("res://effects/explosion.tscn")
var effect: PackedScene = preload("res://assets/BinbunVFX_Vol2/StylizedHitFX/effects/impact/vfx_impact_01.tscn")

func on_roll(dice: Dice) -> void:
	pass

func on_free(dice: Dice) -> void:
	dice.spawn_effect(effect.instantiate())
