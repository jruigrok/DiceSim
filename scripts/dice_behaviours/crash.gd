extends DiceBehaviour
class_name CrashBh

@export var crash_message: String = "Error, crash message"

func on_roll(_dice: Dice, _value: int) -> void:
	OS.crash(crash_message)
