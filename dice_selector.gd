extends CanvasLayer
class_name DiceSelector

@export var dice_set: DiceSet

@onready var h_box_container = $MarginContainer/HBoxContainer
@onready var margin_container = $MarginContainer	

var preview_scene = preload("res://dice_preview.tscn")

func _ready() -> void:
	if dice_set == null:
		push_error("No dice set assigned")
		return
	margin_container.add_theme_constant_override("margin_bottom", 50)
	
	for i in range(dice_set.dice.size()):
		var button = Button.new()
		button.custom_minimum_size = Vector2i(100,100)
		var preview = preview_scene.instantiate()
		preview.dice_mesh = dice_set.dice[i].mesh
		var viewport = preview.get_node("SubViewport")
		viewport.size = button.custom_minimum_size
		var dice_roller = get_parent().get_node("DiceRoller")
		button.pressed.connect(dice_roller._update_dice.bind(
			dice_set.dice[i], dice_set.data
		))
		
		button.add_child(preview)
		h_box_container.add_child(button)
