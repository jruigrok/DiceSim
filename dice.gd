extends RigidBody3D

class_name Dice

@export var dice_data: DiceData
@export var set_data: DiceSetData

@onready var collision_shape = $CollisionShape3D
@onready var mesh_instance = $MeshInstance3D

const VEL_THRESHOLD: float = 0.05
const RESTING_TIMEOUT: float = 0.5
const VEL_THRESHOLD_SQ: float = VEL_THRESHOLD * VEL_THRESHOLD
const POST_ROLL_DELETE_TIMEOUT = 5
const MIN_Y_BOUND = -20.0
var time_tracker: float = 0.0
var rolled: bool = false

func _ready() -> void:
	collision_shape.shape = mesh_instance.mesh.create_convex_shape()
	
func _physics_process(delta: float) -> void:
	if (rolled):
		time_tracker += delta
		if (time_tracker > POST_ROLL_DELETE_TIMEOUT):
			set_data.behaviour.on_free(self)
			queue_free()
	else:
		if (!is_moving()):
			time_tracker += delta
		else:
			time_tracker = 0
		
		if (time_tracker > RESTING_TIMEOUT):
			calculate_roll()
			rolled = true
			time_tracker = 0
			
	if (position.y < MIN_Y_BOUND):
		push_warning("Dice out of bounds")
		queue_free()

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
	
	set_data.behaviour.on_roll(self)
	return best_face

func spawn_dice(sub_dice_data: DiceData, set_data: DiceSetData) -> void:
	pass

func spawn_particles(particles: GPUParticles3D) -> void:
	particles.restart()
	get_parent().add_child(particles)
	particles.global_position = global_position

func spawn_effect(effect: VFXImpactBB):
	get_parent().add_child(effect)
	effect.global_position = global_position
	effect.play()
