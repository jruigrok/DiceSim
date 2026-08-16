extends RigidBody3D

class_name Dice

@export var dice_data: DiceData
@export var set_data: DiceSetData

@onready var collision_shape: CollisionShape3D = %CollisionShape3D
@onready var mesh_instance: MeshInstance3D = %DiceMesh
static var dice_scene := preload("uid://crpslcouesk5p")

enum DiceState {
	ROLLING,
	ROLLED,
	HIDDEN
}

const VEL_THRESHOLD: float = 0.05
const VEL_THRESHOLD_SQ: float = VEL_THRESHOLD * VEL_THRESHOLD
const RESTING_TIMEOUT: float = 0.5
const HIDE_TIMEOUT: float = 5
const FREE_TIMEOUT: float = 5
const MIN_Y_BOUND = -20.0
var time_tracker: float = 0.0
var cur_state: DiceState = DiceState.ROLLING

static func new_dice(_dice_data: DiceData, _set_data: DiceSetData) -> Dice:
	var dice: Dice = dice_scene.instantiate()
	dice.set_data = _set_data
	dice.dice_data = _dice_data
	return dice

func _ready() -> void:
	mesh_instance.mesh = dice_data.mesh
	mesh_instance.material_override = set_data.material
	collision_shape.shape = mesh_instance.mesh.create_convex_shape()
	set_data.handle_on_throw(self)

func _physics_process(delta: float) -> void:
	time_tracker += delta
	handle_state()
	
	if (position.y < MIN_Y_BOUND):
		push_warning("Dice out of bounds")
		queue_free()

func is_moving() -> bool:
	return (angular_velocity.length_squared() > VEL_THRESHOLD_SQ || 
			linear_velocity.length_squared() > VEL_THRESHOLD_SQ)

func handle_state() -> void:
	match (cur_state):
		DiceState.ROLLING:
			if (is_moving()):
				time_tracker = 0
			if (time_tracker > RESTING_TIMEOUT):
				var roll_value: int = dice_data.get_best_face(
					global_transform.basis).value
				set_data.handle_on_roll(self, roll_value)
				GameEvents.dice_rolled.emit(dice_data, set_data, roll_value)
				cur_state = DiceState.ROLLED
				time_tracker = 0
		DiceState.ROLLED:
			if (time_tracker > HIDE_TIMEOUT):
				set_data.handle_on_hide(self)
				cur_state = DiceState.HIDDEN
				mesh_instance.visible = false
				time_tracker = 0
		DiceState.HIDDEN:
			if (time_tracker > FREE_TIMEOUT):
				queue_free()
