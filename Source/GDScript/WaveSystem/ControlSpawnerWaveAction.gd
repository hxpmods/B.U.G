extends WaveAction
class_name ControlSpawnerWaveAction

export var spawnerPath : NodePath
onready var spawner = get_node(spawnerPath)

export var spawnType = "BasicAnt"
export var setActive : bool
export var amountToSpawn: int 
export var spawnRate: float
export var finishOnAmount = -1
var finished : bool = false


func IsCompleted():
	return finished

func Start():
	.Start()
	if setActive:
		if spawner.dormant:
			spawner.SetNormal()
		spawner.Activate(self)
	else:
		spawner.Deactivate()
