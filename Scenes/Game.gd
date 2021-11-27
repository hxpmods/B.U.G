extends Node2D

export var devMode = false
export var initialWave = 5

func _ready():
	if devMode:
		GameManager.StartDevMode(initialWave)
	else:
		GameManager.StartGame()
