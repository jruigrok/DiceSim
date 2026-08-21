extends CanvasLayer
class_name DiceSelector

var dice_set: DiceSet = null

const MAX_ROLL_HISTORY := 10
@onready var dice_selector_container: HBoxContainer = %DiceSelectorContainer
@onready var dice_history_container: VBoxContainer = %DiceHistoryContainer
var preview_scene := preload("uid://dclypq33xt5mr")

func _ready() -> void:
	GameEvents.dice_set_change.connect(on_dice_set_change)
	GameEvents.dice_rolled.connect(on_dice_rolled)

func on_dice_set_change(new_dice_set: DiceSet) -> void:
	dice_set = new_dice_set
	
	for child in dice_selector_container.get_children():
		if child is DicePreview:
			child.queue_free()
	
	setup_previews()

func on_dice_rolled(_dice_data: DiceData, _dice_set: DiceSetData, roll: int) -> void:
	var label := Label.new()
	label.add_theme_font_size_override("font_size", GameEvents.FONT_SIZE)
	label.text = "%s: %s, roll: %d" % (
		[_dice_set.resource_name, _dice_data.resource_name, roll]
	)
	dice_history_container.add_child(label)
	dice_history_container.move_child(label, 0)
	var history_length := dice_history_container.get_child_count()
	while history_length > MAX_ROLL_HISTORY:
		dice_history_container.get_child(history_length - 1).queue_free()
		history_length -= 1
	
	var dice_roll := DiceRoll.new()
	dice_roll.dice_name = _dice_data.resource_name
	dice_roll.dice_set_name = _dice_set.resource_name
	dice_roll.roll = roll
	GameEvents.roll_history.history.push_back(dice_roll)

func setup_previews() -> void:
	for i in range(dice_set.dice.size()):
		var preview: DicePreview = preview_scene.instantiate()
		dice_selector_container.add_child(preview)
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
