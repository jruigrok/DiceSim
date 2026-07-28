extends RigidBody3D

class_name Dice

@export var dice_mesh: PackedScene
@export var dice_data: DiceData

@onready var collision_shape = $CollisionShape3D

const VEL_THRESHOLD: float = 0.05
const RESTING_TIMEOUT: float = 0.0
const VEL_THRESHOLD_SQ: float = VEL_THRESHOLD * VEL_THRESHOLD
var time_resting: float = 0.0

func _init() -> void:
	gravity_scale = 0.0
	angular_damp = 0.0
	angular_damp_mode = RigidBody3D.DAMP_MODE_REPLACE

func _ready() -> void:
	if dice_mesh == null:
		push_error("No dice scene assigned")
		return
	if dice_data == null:
		push_error("No dice data assigned")
		return
	
	var die = dice_mesh.instantiate()
	add_child(die)
	collision_shape.shape = die.mesh.create_convex_shape()

func _process(delta: float) -> void:
	if (!is_moving()):
		time_resting += delta
		if (time_resting > RESTING_TIMEOUT):
			print(calculate_roll())
	else:
		time_resting = 0

func roll() -> void:
	gravity_scale = 1.0
	angular_damp_mode = RigidBody3D.DAMP_MODE_COMBINE
	var init_vel = Vector3((randf() * 10) - 5, randf() * 10, (randf() * 10) - 5)
	var init_avel = Vector3((randf() * 10) - 5, (randf() * 10) - 5, (randf() * 10) - 5)
	linear_velocity = init_vel
	angular_velocity = init_avel

func is_moving() -> bool:
	return (angular_velocity.length_squared() > VEL_THRESHOLD_SQ || 
			linear_velocity.length_squared() > VEL_THRESHOLD_SQ)

func calculate_roll() -> int:
	var best_face = 0
	var best_dot = -INF
	
	for face in dice_data.faces:
		var world_normal = global_transform.basis * face.normal
		
		var d = world_normal.dot(Vector3.UP)
		if d > best_dot:
			best_dot = d
			best_face = face.value
	
	return best_face

func _input(event):
	if event is InputEventMouseButton:
		roll()
