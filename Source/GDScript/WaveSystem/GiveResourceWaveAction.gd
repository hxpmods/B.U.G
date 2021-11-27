extends WaveAction
class_name GiveResourceWaveAction

export var resourceName : String
export var amount : int = 0
var finished = false

func IsCompleted():
	return finished

func Start():
	.Start()
	GameManager.ResourceManager.AddResource(resourceName, amount)
	finished = true
