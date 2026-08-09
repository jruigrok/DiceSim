extends DiceBehaviour
class_name RollLabelBh

@export var font_size := 200

func on_roll(dice: Dice, value: int) -> void:
	var label := Label3D.new()
	label.text = str(value)
	label.top_level = true
	label.position = dice.global_position + Vector3.UP * 0.5
	label.name = "RollLabel"
	label.font_size = 200
	label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	var tween: Tween = dice.create_tween()
	tween.tween_property(
		label,
		"position:y",
		label.position.y + 2,
		1.0
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	dice.add_child(label)

func on_hide(dice: Dice) -> void:
	var label := dice.get_node_or_null("RollLabel") as Label3D
	
	if label:
		label.queue_free()
