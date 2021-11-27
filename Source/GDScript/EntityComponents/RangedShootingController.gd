extends Node

export var shootSpeed = 1.0
export var projectileLauncherPath : NodePath
export var targetingComponentPath : NodePath
export var costsPath : NodePath

export var bulletScene : PackedScene

onready var projectileLauncher = get_node(projectileLauncherPath)
onready var targetingComponent = get_node(targetingComponentPath)

var timerActive= false

func CanShoot():
	return !timerActive

func _ready():
	SetShootSpeed(shootSpeed)
	
func SetShootSpeed( amount):
	shootSpeed = amount
	$Timer.wait_time = 1.0/ shootSpeed

func _process(delta):
	if targetingComponent.HasValidTarget():
		Shoot()

func Shoot():
	if CanShoot():
		if CanAfford():
			for cost in GetCosts():
				GameManager.ResourceManager.Spend(cost)
			var target = targetingComponent.currentTarget
			projectileLauncher.Shoot(bulletScene, target)
			$Timer.start()
			timerActive= true

func _on_Timer_timeout():
	timerActive = false;

func GetCosts():
	var costs :Array
	
	for children in get_children():
		if children.get_class() == "Currency":
			costs.append(children)
			
	return costs

func CanAfford():
	return GameManager.ResourceManager.CanAffordCosts(GetCosts())
