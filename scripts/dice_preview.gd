extends SubViewportContainer
class_name DicePreview

var idx: int
@onready var mesh_instance: MeshInstance3D = %MeshInstance3D
@onready var viewport: SubViewport = %SubViewport

func setup(dice_mesh: Mesh, dice_material: Material, idx_: int) -> void:
	mesh_instance.mesh = dice_mesh
	mesh_instance.material_override = dice_material
	idx = idx_
	viewport.world_3d = World3D.new()
	viewport.size = Vector2i(80,80)

func update_dice(dice_idx: int) -> void:
	viewport.transparent_bg = !(idx == dice_idx)

func _process(delta: float) -> void:
	mesh_instance.rotate_z(delta / 2)
