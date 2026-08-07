extends DiceBehaviour
class_name RandomVelBh

@export var random_speed := true
@export var min_speed := 10.0
@export var max_speed := 20.0
@export var random_angular_speed := true
@export var min_angular_speed := 10.0
@export var max_angular_speed := 20.0

func on_throw(dice: Dice) -> void:
	if random_speed:
		var vel_direction := Vector3(
			randfn(0.0, 1.0),
			randfn(0.0, 1.0),
			randfn(0.0, 1.0)).normalized()
		var speed: float = randf_range(min_speed, max_speed)
		dice.linear_velocity = vel_direction * speed
	
	if random_angular_speed:
		var avel_direction := Vector3(
			randfn(0.0, 1.0),
			randfn(0.0, 1.0),
			randfn(0.0, 1.0)).normalized()
		var angular_speed: float = randf_range(min_angular_speed, max_angular_speed)
		dice.angular_velocity = avel_direction * angular_speed
