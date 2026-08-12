extends CanvasLayer
class_name DiceSelector

@export var dice_set: DiceSet

@onready var h_box_container: HBoxContainer = $MarginContainer/HBoxContainer
@onready var margin_container: MarginContainer = $MarginContainer
@onready var power_bar: ProgressBar = %PowerBar
@onready var dice_roller: DiceRoller = get_parent().get_node("DiceRoller")
var preview_scene := preload("uid://dclypq33xt5mr")
signal select(idx: int)

func _ready() -> void:
	if dice_set == null:
		push_error("No dice set assigned")
		return
	margin_container.add_theme_constant_override("margin_bottom", 10)
	setup_previews()
	
	GameEvents.dice_set_change.connect(on_dice_set_change)

func on_dice_set_change(new_dice_set: DiceSet) -> void:
	dice_set = new_dice_set
	
	for child in h_box_container.get_children():
		if child is DicePreview:
			child.queue_free()
	
	power_bar.visible = false
	setup_previews()

func setup_previews() -> void:
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
			var index: int = event.keycode - KEY_1
			select_dice(index)
