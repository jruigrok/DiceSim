extends VBoxContainer

@onready var back_button := %BackButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	back_button.pressed.connect(on_back_button_pressed)

func on_back_button_pressed() -> void:
	GameEvents.change_to_main_menu_scene()
