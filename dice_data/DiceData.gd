extends Resource
class_name DiceData

@export var name: String
@export var faces: Array[FaceData]
@export var mesh: Mesh

func get_best_face(basis: Basis) -> FaceData:
	var best_face = 0
	var best_dot = -INF
	
	for face in faces:
		var world_normal = basis * face.normal
		var d = world_normal.dot(Vector3.UP)
		if d > best_dot:
			best_dot = d
			best_face = face
	
	return best_face
