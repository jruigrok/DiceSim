extends CanvasLayer
class_name DiceSelector

@export var dice_set: DiceSet

@onready var h_box_container: HBoxContainer = $MarginContainer/HBoxContainer
@onready var margin_container: MarginContainer = $MarginContainer
@onready var power_bar: ProgressBar = %PowerBar
@onready var dice_roller: DiceRoller = get_parent().get_node("DiceRoller")
var preview_scene = preload("res://scenes/dice_preview.tscn")
signal select(idx: int)

func _ready() -> void:
	if dice_set == null:
		push_error("No dice set assigned")
		return
	margin_container.add_theme_constant_override("margin_bottom", 10)
	for i in range(dice_set.dice.size()):
		var preview: DicePreview = preview_scene.instantiate()
		h_box_container.add_child(preview)
		preview.setup(dice_set.dice[i].mesh, dice_set.data.material, i)
		select.connect(preview._on_select)

func select_dice(idx: int) -> void:
	if idx < dice_set.dice.size():
		dice_roller._update_dice(dice_set.dice[idx], dice_set.data)
		select.emit(idx)
		power_bar.visible = true

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode >= KEY_1 and event.keycode <= KEY_9:
			var index = event.keycode - KEY_1
			select_dice(index)
