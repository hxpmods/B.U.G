extends Node

export var splatAudioScene : PackedScene
export var squelchAudioScene : PackedScene
export var pickupAudioScene : PackedScene
export var damageAudioScene : PackedScene
export var placeAudioScene : PackedScene

func _ready():
	GameManager.SetAudioManager(self)

func PlaySplat():
	var audio = splatAudioScene.instance()
	add_child(audio)

func PlaySquelch():
	var audio = squelchAudioScene.instance()
	add_child(audio)

func PlayPickup():
	var audio = pickupAudioScene.instance()
	add_child(audio)

func PlayDamage():
	var audio = damageAudioScene.instance()
	add_child(audio)

func PlayPlace():
	var audio = placeAudioScene.instance()
	add_child(audio)	

func PlayWaveFinished():
	$WaveFinishedPlayer.play()
