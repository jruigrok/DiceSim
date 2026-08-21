extends Resource
class_name DiceData

@export var faces: Array[FaceData]
@export var mesh: Mesh

func get_best_face(basis: Basis) -> FaceData:
	var best_face: FaceData = null
	var best_dot: float = -INF
	
	for face in faces:
		var world_normal := basis * face.normal
		var d := world_normal.dot(Vector3.UP)
		if d > best_dot:
			best_dot = d
			best_face = face
	
	return best_face

func get_min_face() -> FaceData:
	if faces == null:
		push_error("missing faces")
	var min_face: FaceData = faces[0]
	for face in faces:
		min_face = min_face if min_face.value < face.value else face
	return min_face

func get_max_face() -> FaceData:
	if faces == null:
		push_error("missing faces")
	var max_face: FaceData = faces[0]
	for face in faces:
		max_face = max_face if max_face.value > face.value else face
	return max_face
