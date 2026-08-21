extends VBoxContainer
class_name Main_Menu

@onready var play_button := %PlayButton
@onready var settings_button := %SettingsButton

func _ready() -> void:
	play_button.pressed.connect(on_play_button_pressed)
	settings_button.pressed.connect(on_settings_button_pressed)

func on_play_button_pressed() -> void:
	GameEvents.change_to_game_scene()

func on_settings_button_pressed() -> void:
	pass
