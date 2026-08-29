extends DiceBehaviour
class_name EffectBh

@export var effect_sc: PackedScene
@export var effect_event: Event = Event.ON_HIDE
@export var on_touch_vel_threshold := 3.0

func on_roll(dice: Dice, _value: int) -> void:
	if effect_event == Event.ON_ROLL:
		var effect := add_effect(dice)
		effect.play()

func on_throw(dice: Dice) -> void:
	if effect_event == Event.ON_ROLL:
		var effect := add_effect(dice)
		effect.play()
	
	elif effect_event == Event.ON_TOUCH:
		dice.contact_monitor = true
		dice.max_contacts_reported = 1
		var effect := add_effect(dice)
		dice.body_entered.connect(
			func(_body: Node) -> void:
				if ((dice.linear_velocity.length_squared() > 
					on_touch_vel_threshold * on_touch_vel_threshold)):
					effect.play()
		)

func on_hide(dice: Dice) -> void:
	if effect_event == Event.ON_HIDE:
		var effect := add_effect(dice)
		effect.play()

func add_effect(dice: Dice) -> VFXControllerBB:
	var effect: VFXControllerBB = effect_sc.instantiate()
	dice.add_child(effect)
	return effect
