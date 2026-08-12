extends Node

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		match (GameEvents.game_state):
			GameEvents.GameState.SET_SELECTOR:
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
				GameEvents.change_game_state(GameEvents.GameState.DICE_SIM)
			GameEvents.GameState.DICE_SIM:
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
				GameEvents.change_game_state(GameEvents.GameState.SET_SELECTOR)
