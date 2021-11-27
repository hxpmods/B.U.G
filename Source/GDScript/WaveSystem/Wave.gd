extends Node
class_name Wave

var active = false
var currentPhase : WaveAction
var finished = false


func StartWave():
	active = true
	
func FinishWave():
	active = false
	get_parent().WaveFinished(self)
	finished = true

func IsCompleted():
	return finished

func _process(delta):
	if active:
		
		
		if currentPhase == null:
			currentPhase = GetNextUncompletedPhase()
		
		if currentPhase == null:
			FinishWave()
		else:
			if !currentPhase.started:
				currentPhase.Start()
				
			if currentPhase.IsCompleted():
				currentPhase = null

func GetNextUncompletedPhase():
	for child in get_children():
		if !child.IsCompleted():
			return child
