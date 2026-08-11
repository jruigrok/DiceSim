extends Node
class_name GameEvents

signal dice_set_change(dice_set: DiceSet)
signal game_state_change(game_state: GameState)
var game_state := GameState.SET_SELECTOR

enum GameState {
	SET_SELECTOR,
	DICE_SIM
}

func _ready() -> void:
	change_game_state(game_state)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		match (game_state):
			GameState.SET_SELECTOR:
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
				change_game_state(GameState.DICE_SIM)
			GameState.DICE_SIM:
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
				change_game_state(GameState.SET_SELECTOR)

func change_game_state(new_state: GameState) -> void:
	game_state = new_state
	game_state_change.emit(game_state)
