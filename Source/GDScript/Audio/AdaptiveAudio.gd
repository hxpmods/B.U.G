extends AudioStreamPlayer
tool

export var intensity : float = 1 setget setIntensity
export var att : float = 10
export var power : float = 1.0
export var max_volume = 0
export var _floor : float = -60

func setIntensity(amount):
	intensity = amount;
	volume_db = min(max_volume,_floor+ pow(att*intensity, power))
