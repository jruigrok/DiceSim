extends CanvasLayer
class_name InGameMenu

@onready var set_selector_container := %SetSelectorContainer
@onready var roll_history_container := %RollHistoryContainer
@onready var exit_button := %ExitButton

@export var sets: Array[DiceSet]
const BUTTON_SIZE := Vector2i(200,50)

func _ready() -> void:
	GameEvents.game_state_change.connect(on_game_state_change)
	exit_button.pressed.connect(on_exit_pressed)
	
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
		button.alignment = HORIZONTAL_ALIGNMENT_CENTER
		set_selector_container.add_child(button)

func on_game_state_change(game_state: GameEvents.GameState) -> void:
	match (game_state):
		GameEvents.GameState.GAME_MENU:
			update_roll_history()
			visible = true
		GameEvents.GameState.DICE_SIM:
			visible = false

func on_exit_pressed() -> void:
	GameEvents.change_to_main_menu_scene()

func update_roll_history() -> void:
	for child in roll_history_container.get_children():
		child.queue_free()
	
	for i in range(GameEvents.roll_history.history.size() - 1, -1, -1):
		var dice_roll := GameEvents.roll_history.history[i]
		var label := Label.new()
		label.add_theme_font_size_override("font_size", 10)
		label.text = "%s: %s, roll: %d" % (
			[dice_roll.dice_set_name, dice_roll.dice_name, dice_roll.roll]
		)
		roll_history_container.add_child(label)
