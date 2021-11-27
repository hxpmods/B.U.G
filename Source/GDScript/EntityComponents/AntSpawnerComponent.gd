extends Node2D

export var spawnAmount = 1
export var typeToSpawn = "BasicAnt"
export var spawnSpread = 8

func _on_ant_OnAntDie(ant):
	for i in range(spawnAmount):
		var pos = ant.lastKnownPos+ Vector2(rand_range(-spawnSpread, spawnSpread),rand_range(-spawnSpread, spawnSpread))
		GameManager.AntManager.SpawnAtPos(typeToSpawn, pos)
