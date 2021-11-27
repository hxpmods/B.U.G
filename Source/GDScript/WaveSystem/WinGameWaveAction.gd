extends WaveAction
class_name WaitWaveAction

export var waitTime : float = 1
var finished = false

func IsCompleted():
	return finished

func Start():
	.Start()
	yield(get_tree().create_timer(waitTime),"timeout")
	finished = true
