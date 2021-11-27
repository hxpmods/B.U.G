extends Node2D

onready var antScene = preload("res://Scenes/ant.tscn")
onready var pheremoneManager =get_node("../PheremoneMap")
export var goalAntAmount = 500
var currentAntCount = 0 setget SetCurrentAntCount
var spawnThisWave = 0;
signal OnAntCountChanged(amount)
signal OnAntSpawned()

var currentSpawnAmount = 1;

func SpawnWave(var amount : int):
	spawnThisWave += amount;
		
func SetCurrentAntCount( value : int):
	currentAntCount = value;
	emit_signal("OnAntCountChanged", currentAntCount);
		
func _process(delta):
	if spawnThisWave > 0:
		var instance = antScene.instance()
		var pos = pheremoneManager.GetRandomPosInRange();
		instance.position = pos
		instance.pheremoneManager = pheremoneManager
		instance.goal = get_node("../EntityManager/Goal")
		add_child(instance)
		
		spawnThisWave = max(spawnThisWave-1 ,0)
		
	SetCurrentAntCount(get_child_count())


func _on_Timer_timeout():
	var random = currentSpawnAmount + 1
	currentSpawnAmount = random
	
	goalAntAmount += 10
	
	if get_child_count() +spawnThisWave + random <= goalAntAmount:
		SpawnWave(random)
	else:
		SpawnWave(goalAntAmount - get_child_count() - spawnThisWave)
