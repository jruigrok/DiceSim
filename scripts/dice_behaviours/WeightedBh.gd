extends DiceBehaviour
class_name WeightedBh

@export var default_weighted_face_value: int = 1
@export var weight: float = 0.1
@export var weight_face := WeightFace.MIN_FACE

enum WeightFace {
	MIN_FACE,
	MAX_FACE
}

func on_throw(dice: Dice) -> void:
	var weighted_face: FaceData
	
	match (weight_face):
		WeightFace.MIN_FACE:
			weighted_face = dice.dice_data.get_min_face()
		WeightFace.MAX_FACE:
			weighted_face = dice.dice_data.get_max_face()
	
	dice.center_of_mass = weight * weighted_face.normal
