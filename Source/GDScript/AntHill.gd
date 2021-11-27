extends Sprite

var active = false
var amountToSpawn = 0;
var spawnType = "BasicAnt"
var amountLeftToSpawn = 0;
var currentController;

var dormant = true

export var dormantTexture : Texture
export var normalTexture : Texture

func _ready():
	if dormant:
		SetDormant()
	else:
		SetNormal()

func SetNormal():
	dormant = false
	texture = normalTexture
	
func SetDormant():
	dormant = true
	texture = dormantTexture

onready var antManager = get_node("../../AntManager")

func Activate( wave : ControlSpawnerWaveAction):
	
	currentController = wave;
	
	active=  true
	self.amountToSpawn = wave.amountToSpawn
	self.amountLeftToSpawn = self.amountToSpawn
	self.spawnType = wave.spawnType
	
	$Timer.wait_time = 1.0/wave.spawnRate
	$Timer.start()
	
func Deactivate():
	active = false
	$Timer.stop()

func _on_Timer_timeout():
	if amountLeftToSpawn > 0:
		antManager.SpawnAtPos(spawnType,$SpawnMarker.global_position)
		amountLeftToSpawn -= 1
	
	if currentController.finishOnAmount > -1:
		if amountLeftToSpawn == amountToSpawn - currentController.finishOnAmount:
			currentController.finished = true;
	
	if amountLeftToSpawn == 0:
		currentController.finished = true;
		Deactivate()
