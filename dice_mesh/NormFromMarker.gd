@tool
extends MeshInstance3D

@export var dice_data_path: String

@export_tool_button("Generate DiceData From Markers") var generate_button = generate_dice_data

func generate_dice_data():
	var dice_data = DiceData.new()

	for child in get_children():
		if child is Marker3D:
			var face = FaceData.new()
			var world_normal = child.global_transform.basis.y
			face.normal = global_transform.basis.inverse() * world_normal
			face.value = child.get_meta("value")
			dice_data.faces.append(face)

	ResourceSaver.save(dice_data, dice_data_path)

	print("Generated DiceData!")
