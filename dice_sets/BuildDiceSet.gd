@tool
extends Node

@export var set_name: String
@export var gen_dice_enables: Dictionary = {
	"d_4": true,
	"d_6": true,
	"d_8": true,
	"d_10": true,
	"d_12": true,
	"d_20": true,
}
@export var mesh_path = "res://dice_mesh/"
@export var data_path = "res://dice_data/"
@export var set_file = "res://dice_sets/"
@export var material : StandardMaterial3D

@export_tool_button("Generate Dice Set") var generate_button =  generate_dice_set

func generate_dice_set():
	var dice_set = DiceSet.new()
	dice_set.material = material
	for dice_type in gen_dice_enables:
		if gen_dice_enables[dice_type]:
			var dice_def = DiceDef.new()
			dice_def.name = set_name + "_" + dice_type
			var scene = load(mesh_path + dice_type + ".tscn")
			dice_def.mesh = scene.instantiate().mesh
			dice_def.dice_data = load(NodePath(data_path + dice_type + ".tres"))
			dice_set.dice.append(dice_def)
	
	ResourceSaver.save(dice_set, set_file + set_name + ".tres")
	print("Generated Dice Set!")
