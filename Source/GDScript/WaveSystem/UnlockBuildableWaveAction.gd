extends WaveAction
class_name UnlockBuildableWaveAction

export var buildableName : String
var finished = false

func IsCompleted():
	return finished

func Start():
	.Start()
	GameManager.Buildables.get_node(buildableName).SetUnlocked(true)
	finished = true
