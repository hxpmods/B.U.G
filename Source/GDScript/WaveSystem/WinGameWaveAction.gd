extends WaveAction
class_name WinGameWaveAction

var finished = false

func IsCompleted():
	return finished

func Start():
	GameManager.WinGame()
	finished = true
