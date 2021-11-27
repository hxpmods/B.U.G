extends AudioStreamPlayer
export var pitch_base : float = 1.0

func _ready():
	pitch_scale = pitch_base*rand_range(0.8, 1.2)

func _on_AudioStreamPlayer_finished():
	playing = false
	self.queue_free()
