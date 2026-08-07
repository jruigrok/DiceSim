extends DiceBehaviour
class_name WeightedBh

@export var default_weighted_face: int = 1
@export var weight: float = 0.1
@export var weighted_face_override: Dictionary[String, int] = {}

func on_throw(dice: Dice) -> void:
	var dice_data: DiceData = dice.dice_data
	var weighted_face: int = weighted_face_override.get(dice_data.name, default_weighted_face)

	for face: FaceData in dice.dice_data.faces:
		if (face.value == weighted_face):
			dice.center_of_mass = weight * face.normal
			print("COM set to:", dice.center_of_mass)
			return

	push_error("Face not found in dice: " + str(weighted_face))
