extends WaveAction
class_name CheckAntDeathAction

var finished = false

func IsCompleted():
	if !finished:
		finished = get_node("../../../AntManager").get_child_count() == 0
	return finished

func Start():
	.Start()
