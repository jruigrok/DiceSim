extends StaticBody3D

@onready var floor_mesh: MeshInstance3D = $Floor

var THICKNESS: float = 0.2

func _ready() -> void:
	var mesh_size: Vector2 = floor_mesh.mesh.size
	var width = mesh_size.x * floor_mesh.scale.x
	var depth = mesh_size.y * floor_mesh.scale.z
	var collider = CollisionShape3D.new()
	var shape = BoxShape3D.new()
	shape.size = Vector3(width, THICKNESS, depth)
	collider.shape = shape
	build_walls(width, depth, 5.0)
	add_child(collider)

func build_walls(width: float, depth: float, wall_height: float):
	var configs = [
		{"pos": Vector3(0, wall_height/2, -depth/2), "size": Vector3(width, wall_height, THICKNESS)},
		{"pos": Vector3(0, wall_height/2,  depth/2), "size": Vector3(width, wall_height, THICKNESS)},
		{"pos": Vector3( width/2, wall_height/2, 0), "size": Vector3(THICKNESS, wall_height, depth)},
		{"pos": Vector3(-width/2, wall_height/2, 0), "size": Vector3(THICKNESS, wall_height, depth)},
	]

	for cfg in configs:
		var body = StaticBody3D.new()
		var collider = CollisionShape3D.new()
		var shape = BoxShape3D.new()
		shape.size = cfg["size"]
		collider.shape = shape
		body.add_child(collider)
		body.position = cfg["pos"]
		add_child(body)

		var mesh_instance = MeshInstance3D.new()
		var box_mesh = BoxMesh.new()
		box_mesh.size = cfg["size"]
		mesh_instance.mesh = box_mesh
		box_mesh.material = preload("res://materials/floor_mat.tres")
		body.add_child(mesh_instance)
