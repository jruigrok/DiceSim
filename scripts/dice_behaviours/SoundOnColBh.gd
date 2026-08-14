extends DiceBehaviour
class_name SoundOnColBh

@export var audio_stream: AudioStream
@export var cooldown := 0.05
@export var vel_threshold := 3.0

func on_throw(dice: Dice) -> void:
	dice.contact_monitor = true
	dice.max_contacts_reported = 1
	var audio_stream_player := AudioStreamPlayer.new()
	audio_stream_player.stream = audio_stream
	dice.add_child(audio_stream_player)
	
	var timer := Timer.new()
	timer.wait_time = cooldown
	timer.one_shot = true
	dice.add_child(timer)
	
	dice.body_entered.connect(
		func(_body: Node) -> void:
			if timer.is_stopped() && (
					dice.linear_velocity.length_squared() > 
					vel_threshold * vel_threshold):
				timer.start()
				audio_stream_player.play()
	)
