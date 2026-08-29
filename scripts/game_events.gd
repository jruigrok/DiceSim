extends Node

const STATS_FILE_PATH := "user://stats.save"
const FONT_SIZE := 10

@warning_ignore("unused_signal")
signal dice_set_change(dice_set: DiceSet)
signal game_state_change(game_state: GameState)
@warning_ignore("unused_signal")
signal update_dice(dice_set: DiceSet, dice_data: DiceData)
@warning_ignore("unused_signal")
signal dice_rolled(dice_data: DiceData, dice_set: DiceSetData, roll: int)

signal game_ready()

var game_scene := preload("uid://cj34pdrglpueo")
var main_menu_scene := preload("uid://cx4t77cp6wg1k")
var game_state := GameState.GAME_MENU
@onready var roll_history: DiceRollHistory = DiceRollHistory.new()
var stats_dict: Dictionary = {}

enum GameState {
	GAME_MENU,
	DICE_SIM
}

func _ready() -> void:
	game_ready.connect(on_game_ready)
	load_stats()

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		save_stats()

func change_game_state(new_state: GameState) -> void:
	game_state = new_state
	game_state_change.emit(game_state)

func change_to_game_scene() -> void:
	get_tree().change_scene_to_packed(game_scene)

func change_to_main_menu_scene() -> void:
	get_tree().change_scene_to_packed(main_menu_scene)

func on_game_ready() -> void:
	change_game_state(game_state)

func add_stat(dice_data: DiceData, dice_set: DiceSetData, roll: int) -> void:
	var dice_set_name := dice_set.resource_name
	var dice_name := dice_data.resource_name

	if not stats_dict.has(dice_set_name):
		stats_dict[dice_set_name] = {}

	if not stats_dict[dice_set_name].has(dice_name):
		stats_dict[dice_set_name][dice_name] = {}

	var rolls: Dictionary = stats_dict[dice_set_name][dice_name]
	rolls[str(roll)] = rolls.get(str(roll), 0) + 1

func load_stats() -> void:
	if FileAccess.file_exists(STATS_FILE_PATH):
		var file := FileAccess.open(STATS_FILE_PATH, FileAccess.READ)
		var data: Variant = JSON.parse_string(file.get_as_text())
		if data is Dictionary:
			stats_dict = JSON.parse_string(file.get_as_text())
		file.close()

func save_stats() -> void:
	if stats_dict.is_empty():
		return
	var file := FileAccess.open(STATS_FILE_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify(stats_dict))
	file.close()

func clear_stats() -> void:
	stats_dict.clear()
	DirAccess.remove_absolute(STATS_FILE_PATH)
