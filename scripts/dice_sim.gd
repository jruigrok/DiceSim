extends Node3D

func _ready() -> void:
	GameEvents.game_state_change.connect(on_game_state_change)

func on_game_state_change(new_state: GameEvents.GameState) -> void:
	match (new_state):
		GameEvents.GameState.SET_SELECTOR:
			process_mode = Node.PROCESS_MODE_DISABLED
		GameEvents.GameState.DICE_SIM:
			process_mode = Node.PROCESS_MODE_INHERIT
