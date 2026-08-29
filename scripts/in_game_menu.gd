extends CanvasLayer
class_name InGameMenu

@onready var set_selector_container := %SetSelectorContainer
@onready var roll_history_container := %RollHistoryContainer
@onready var stats_container := %StatsContainer
@onready var exit_button := %ExitButton
@onready var clear_stats_button := %ClearStatsButton

@export var sets: Array[DiceSet]
const BUTTON_SIZE := Vector2i(200,50)

func _ready() -> void:
	GameEvents.game_state_change.connect(on_game_state_change)
	exit_button.pressed.connect(on_exit_pressed)
	clear_stats_button.pressed.connect(on_clear_stats_pressed)
	
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
	
	var make_label := func(text: String) -> Label:
		var label := Label.new()
		label.text = text
		label.add_theme_font_size_override("font_size", GameEvents.FONT_SIZE)
		return label
	
	var total_rolls: int = 0
	
	for dice_set_name: String in GameEvents.stats_dict:
		var set_rolls: int = 0
		var set_foldable_container: FoldableContainer = make_foldable.call(dice_set_name)
		stats_container.add_child(set_foldable_container)
		var set_vbox := VBoxContainer.new()
		var set_margin := MarginContainer.new()
		set_margin.add_theme_constant_override("margin_left", 20)
		set_foldable_container.add_child(set_margin)
		set_margin.add_child(set_vbox)
		
		for dice_name: String in GameEvents.stats_dict[dice_set_name]:
			var dice_rolls: int = 0
			var total_roll_value: int = 0
			var dice_foldable_container: FoldableContainer = make_foldable.call(dice_name)
			var dice_vbox := VBoxContainer.new()
			set_vbox.add_child(dice_foldable_container)
			dice_foldable_container.add_child(dice_vbox)
			var stats_string := ""
			
			for roll_value: String in GameEvents.stats_dict[dice_set_name][dice_name]:
				var num_rolls: int = GameEvents.stats_dict[dice_set_name][dice_name][roll_value] as int
				dice_rolls += num_rolls
				total_roll_value += num_rolls * int(roll_value)
				if not stats_string.is_empty():
					stats_string += "\n"
				stats_string += "%s: %d" % [roll_value, num_rolls]
			set_rolls += dice_rolls
			dice_vbox.add_child(make_label.call(stats_string))
			dice_vbox.add_child(make_label.call("num rolls: %d" % [dice_rolls]))
			dice_vbox.add_child(make_label.call("avg roll: %.2f" % [total_roll_value as float / dice_rolls]))
		total_rolls += set_rolls
		set_vbox.add_child(make_label.call("num rolls: %d" % [set_rolls]))
	stats_container.add_child(make_label.call("num rolls: %d" % [total_rolls]))

func on_clear_stats_pressed() -> void:
	GameEvents.clear_stats()
	update_stats()
