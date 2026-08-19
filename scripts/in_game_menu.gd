extends CanvasLayer
class_name InGameMenu

@onready var set_selector_container := %SetSelectorContainer
@onready var roll_history_container := %RollHistoryContainer
@onready var stats_container := %StatsContainer
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
			update_stats()
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
		label.add_theme_font_size_override("font_size", GameEvents.FONT_SIZE)
		label.text = "%s: %s, roll: %d" % (
			[dice_roll.dice_set_name, dice_roll.dice_name, dice_roll.roll]
		)
		roll_history_container.add_child(label)

func update_stats() -> void:
	for child in stats_container.get_children():
		child.queue_free()
	
	var make_foldable := func(title: String) -> FoldableContainer:
		var foldable_container := FoldableContainer.new()
		foldable_container.folded = true
		foldable_container.title = title
		foldable_container.add_theme_font_size_override("font_size", GameEvents.FONT_SIZE)
		return foldable_container
	
	for dice_set_name: String in GameEvents.stats_dict:
		var set_foldable_container: FoldableContainer = make_foldable.call(dice_set_name)
		stats_container.add_child(set_foldable_container)
		var set_vbox := VBoxContainer.new()
		var set_margin := MarginContainer.new()
		set_margin.add_theme_constant_override("margin_left", 20)
		set_foldable_container.add_child(set_margin)
		set_margin.add_child(set_vbox)
		for dice_name: String in GameEvents.stats_dict[dice_set_name]:
			var dice_foldable_container: FoldableContainer = make_foldable.call(dice_name)
			set_vbox.add_child(dice_foldable_container)
			var stats_string := ""
			for stat_name: Variant in GameEvents.stats_dict[dice_set_name][dice_name]:
				var stat: Variant = GameEvents.stats_dict[dice_set_name][dice_name][stat_name]
				if not stats_string.is_empty():
					stats_string += "\n"
				stats_string += "%s: %s" % [str(stat_name), str(stat)]
			var label := Label.new()
			label.text = stats_string
			label.add_theme_font_size_override("font_size", GameEvents.FONT_SIZE)
			dice_foldable_container.add_child(label)
