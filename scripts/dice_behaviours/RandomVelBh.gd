extends DiceBehaviour
class_name RandomVelBh

@export var min_speed := 10.0
@export var max_speed := 20.0

func on_throw(dice: Dice) -> void:
	var direction := Vector3(
		randfn(0.0, 1.0),
		randfn(0.0, 1.0),
		randfn(0.0, 1.0)).normalized()
	
	var speed: float = randf_range(min_speed, max_speed)
	dice.linear_velocity = direction * speed
	
