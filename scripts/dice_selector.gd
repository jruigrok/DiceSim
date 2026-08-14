extends CanvasLayer
class_name DiceSelector

var dice_set: DiceSet = null

@onready var h_box_container: HBoxContainer = $MarginContainer/HBoxContainer
@onready var margin_container: MarginContainer = $MarginContainer
var preview_scene := preload("uid://dclypq33xt5mr")

func _ready() -> void:
	margin_container.add_theme_constant_override("margin_bottom", 10)
	GameEvents.dice_set_change.connect(on_dice_set_change)

func on_dice_set_change(new_dice_set: DiceSet) -> void:
	dice_set = new_dice_set
	
	for child in h_box_container.get_children():
		if child is DicePreview:
			child.queue_free()
	
	setup_previews()

func setup_previews() -> void:
	for i in range(dice_set.dice.size()):
		var preview: DicePreview = preview_scene.instantiate()
		h_box_container.add_child(preview)
		preview.setup(dice_set.dice[i].mesh, dice_set.data.material, i)
		preview.add_to_group("dice previews")

func select_dice(idx: int) -> void:
	if dice_set != null && idx < dice_set.dice.size():
		GameEvents.update_dice.emit(dice_set.dice[idx], dice_set.data)
		get_tree().call_group("dice previews", "update_dice", idx)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode >= KEY_1 and event.keycode <= KEY_9:
			var index: int = event.keycode - KEY_1
			select_dice(index)
