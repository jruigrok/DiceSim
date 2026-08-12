extends Node

signal dice_set_change(dice_set: DiceSet)
signal game_state_change(game_state: GameState)
var game_state := GameState.SET_SELECTOR

enum GameState {
	SET_SELECTOR,
	DICE_SIM
}

func _ready() -> void:
	change_game_state(game_state)

func change_game_state(new_state: GameState) -> void:
	game_state = new_state
	game_state_change.emit(game_state)
