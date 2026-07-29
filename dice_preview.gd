extends SubViewportContainer
class_name DicePreview

@export var dice_mesh: Mesh
@onready var mesh_instance = $SubViewport/Node3D/MeshInstance3D
@onready var viewport = $SubViewport

func _init() -> void:
	pass

func _ready() -> void:
	mesh_instance.mesh = dice_mesh
	viewport.world_3d = World3D.new()

func _process(delta: float) -> void:
	mesh_instance.rotate_x(delta / 4)
	mesh_instance.rotate_y(delta / 2)
