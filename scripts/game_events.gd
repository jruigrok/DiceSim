extends Node

@warning_ignore("unused_signal")
signal dice_set_change(dice_set: DiceSet)
signal game_state_change(game_state: GameState)
@warning_ignore("unused_signal")
signal update_dice(dice_set: DiceSet, dice_data: DiceData)
signal game_ready()

var game_scene := preload("uid://cj34pdrglpueo")
var game_state := GameState.SET_SELECTOR

enum GameState {
	SET_SELECTOR,
	DICE_SIM
}

func _ready() -> void:
	game_ready.connect(on_game_ready)

func change_game_state(new_state: GameState) -> void:
	game_state = new_state
	game_state_change.emit(game_state)

func change_to_game_scene() -> void:
	get_tree().change_scene_to_packed(game_scene)

func on_game_ready() -> void:
	change_game_state(game_state)
