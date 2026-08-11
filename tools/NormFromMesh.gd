@tool
extends MeshInstance3D

@export var dice_data_path: String

@export_tool_button("Generate DiceData From Mesh") var generate_button = generate_dice_data

func generate_dice_data():
	var dice_data = DiceData.new()

	var mesh_data = mesh.surface_get_arrays(0)
	var vertices = mesh_data[Mesh.ARRAY_VERTEX]
	var indices = mesh_data[Mesh.ARRAY_INDEX]

	var normals: Array[Vector3] = []

	for i in range(0, indices.size(), 3):
		var a = vertices[indices[i]]
		var b = vertices[indices[i + 1]]
		var c = vertices[indices[i + 2]]

		var normal = (b - a).cross(c - a).normalized()

		if not contains_normal(normals, normal):
			normals.append(normal)

	for i in range(normals.size()):
		var face = FaceData.new()
		face.normal = normals[i]
		face.value = -i

		dice_data.faces.append(face)

	ResourceSaver.save(dice_data, dice_data_path)

	print("Generated ", normals.size(), " faces")

func contains_normal(normals: Array[Vector3], normal: Vector3) -> bool:
	for n in normals:
		if n.dot(normal) > 0.99:
			return true
	return false
