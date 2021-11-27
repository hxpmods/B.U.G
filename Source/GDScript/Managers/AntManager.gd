extends Node2D

var antPools: Dictionary

onready var pheremoneManager =get_node("../PheremoneMap")

signal OnAntKilled()

# Called when the node enters the scene tree for the first time.
func _ready():
	
	GameManager.SetAntManager(self)
	
	for spawnable in GameManager.Spawnables.get_children():
		antPools[spawnable.name] = []
		
		for i in range(spawnable.poolSize):
			var ant = InstanceSpawnable(spawnable)
			antPools[spawnable.name].append(ant)

func InstanceSpawnable( var spawnable):
	var instance = spawnable.sceneToSpawn.instance()
	instance.pheremoneManager = pheremoneManager
	instance.set_process(false)
	return instance

func SpawnAtPos(spawnableName : String,pos: Vector2):
	var ant = antPools[spawnableName].pop_front()
	
	ant.global_position = pos
	ant.connect("OnAntDie",self,"HandleAntDeath")
	ant.set_process(true)
	ant.Reset()
	add_child(ant)
	ant.FindGoal()
	
func HandleAntDeath(ant : Node2D):
	ant.set_process(false)
	ant.disconnect("OnAntDie", self, "HandleAntDeath")
	remove_child(ant);
	emit_signal("OnAntKilled");
	antPools[ant.spawnGroup].append(ant)
