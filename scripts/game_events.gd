extends Node

const DICE_ROLL_HISTORY_FILE_PATH := "user://dice_roll_history.res"

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
var roll_history: DiceRollHistory

enum GameState {
	GAME_MENU,
	DICE_SIM
}

func _ready() -> void:
	game_ready.connect(on_game_ready)

func change_game_state(new_state: GameState) -> void:
	game_state = new_state
	game_state_change.emit(game_state)

func change_to_game_scene() -> void:
	if FileAccess.file_exists(DICE_ROLL_HISTORY_FILE_PATH):
		roll_history = ResourceLoader.load(DICE_ROLL_HISTORY_FILE_PATH)
	else:
		roll_history = DiceRollHistory.new()
	
	get_tree().change_scene_to_packed(game_scene)

func change_to_main_menu_scene() -> void:
	get_tree().change_scene_to_packed(main_menu_scene)

func on_game_ready() -> void:
	change_game_state(game_state)
