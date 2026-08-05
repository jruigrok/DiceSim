extends Label3D

func display(value: int) -> void:
	text = str(value)
	visible = true
	position = get_parent().global_position + Vector3.UP * 0.5
	var tween: Tween = create_tween()
	tween.tween_property(
		self,
		"position:y",
		position.y + 2,
		1.0
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

func _on_hide() -> void:
	visible = false
