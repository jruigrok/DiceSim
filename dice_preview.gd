extends SubViewportContainer
class_name DicePreview

@export var dice_mesh: Mesh
@export var dice_material = Material
@onready var mesh_instance = $SubViewport/Node3D/MeshInstance3D
@onready var viewport = $SubViewport

func _init() -> void:
	pass

func _ready() -> void:
	mesh_instance.mesh = dice_mesh
	mesh_instance.material_override = dice_material
	
	viewport.world_3d = World3D.new()

func _process(delta: float) -> void:
	mesh_instance.rotate_z(delta / 2)
