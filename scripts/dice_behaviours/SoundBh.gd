extends DiceBehaviour
class_name SoundBh

@export var audio_stream: AudioStream
@export var cooldown := 0.05
@export var vel_threshold := 3.0
@export var sound_event: Event = Event.ON_TOUCH
@export var volume_db: float = 0.0

func on_throw(dice: Dice) -> void:
	if sound_event == Event.ON_THROW:
		var audio_stream_player := add_stream(dice)
		audio_stream_player.play()
	
	elif sound_event == Event.ON_TOUCH:
		dice.contact_monitor = true
		dice.max_contacts_reported = 1
		var audio_stream_player := add_stream(dice)
		
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

func on_roll(dice: Dice, _value: int) -> void:
	if sound_event == Event.ON_ROLL:
		var audio_stream_player := add_stream(dice)
		audio_stream_player.play()

func on_hide(dice: Dice) -> void:
	if sound_event == Event.ON_HIDE:
		var audio_stream_player := add_stream(dice)
		audio_stream_player.play()

func add_stream(dice: Dice) -> AudioStreamPlayer3D:
	var audio_stream_player := AudioStreamPlayer3D.new()
	audio_stream_player.volume_db = volume_db
	audio_stream_player.stream = audio_stream
	dice.add_child(audio_stream_player)
	return audio_stream_player
