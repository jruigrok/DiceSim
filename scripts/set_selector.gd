extends CanvasLayer
class_name SetSelector

@onready var vbox_container := %VBoxContainer

@onready var game_events: GameEvents = get_tree().current_scene as GameEvents
@export var sets: Array[DiceSet]
const BUTTON_SIZE := Vector2i(200,50)

func _ready() -> void:
	game_events.game_state_change.connect(on_game_state_change)
	
	for dice_set: DiceSet in sets:
		var button := Button.new()
		button.custom_minimum_size = BUTTON_SIZE
		button.text = dice_set.resource_name
		button.pressed.connect(
			func () -> void:
				game_events.dice_set_change.emit(dice_set)
		)
		vbox_container.add_child(button)

func on_game_state_change(game_state: GameEvents.GameState) -> void:
	match (game_state):
		GameEvents.GameState.SET_SELECTOR:
			visible = true
		GameEvents.GameState.DICE_SIM:
			visible = false
