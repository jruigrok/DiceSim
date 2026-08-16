extends CanvasLayer
class_name SetSelector

@onready var vbox_container := %VBoxContainer

@export var sets: Array[DiceSet]
const BUTTON_SIZE := Vector2i(200,50)

func _ready() -> void:
	GameEvents.game_state_change.connect(on_game_state_change)
	var button_group := ButtonGroup.new()
	
	for dice_set: DiceSet in sets:
		var button := Button.new()
		button.custom_minimum_size = BUTTON_SIZE
		button.text = dice_set.resource_name
		button.toggle_mode = true
		button.button_group = button_group
		button.pressed.connect(
			func () -> void:
				GameEvents.dice_set_change.emit(dice_set)
		)
		button.tooltip_text = dice_set.data.description
		vbox_container.add_child(button)

func on_game_state_change(game_state: GameEvents.GameState) -> void:
	match (game_state):
		GameEvents.GameState.SET_SELECTOR:
			visible = true
		GameEvents.GameState.DICE_SIM:
			visible = false
