extends HBoxContainer
class_name Main_Menu

@onready var play_button := %PlayButton

func _ready() -> void:
	play_button.pressed.connect(on_play_button_pressed)

func on_play_button_pressed() -> void:
	GameEvents.change_to_game_scene()
