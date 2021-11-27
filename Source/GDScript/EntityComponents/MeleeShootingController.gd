extends Node

export var projectilesAtOnce = 1
export var shootSpeed = 1.0
export var projectileLauncherPath : NodePath
export var targetingComponentPath : NodePath
export var harvestingComponentPath : NodePath

export var bulletScene : PackedScene
export var harvestBulletScene : PackedScene

onready var projectileLauncher = get_node(projectileLauncherPath)
onready var targetingComponent = get_node(targetingComponentPath)
onready var harvestingComponent = get_node(harvestingComponentPath)

var isFighting = false
var harvestableTarget = null

var timerActive= false

func _process(delta):
	
		if targetingComponent.HasValidTarget():
			isFighting = true
			ShootNormal()
		elif harvestingComponent.HasValidTarget():
			isFighting = false
			ShootHarvest()

func _ready():
	SetShootSpeed(shootSpeed)

func CanShoot():
	var flag = !timerActive
	return projectileLauncher.activeProjectiles.size() < projectilesAtOnce and flag

func ShootNormal():
	if CanShoot():
		var target = targetingComponent.currentTarget
		projectileLauncher.Shoot(bulletScene, target)
		$Timer.start()
		timerActive= true

func ShootHarvest():
	if CanShoot():
		var target = harvestingComponent.currentTarget
		projectileLauncher.Shoot(harvestBulletScene, target)
		$Timer.start()
		timerActive = true

func SetShootSpeed( amount):
	shootSpeed = amount
	$Timer.wait_time = 1.0/ shootSpeed

func _on_Timer_timeout():
	timerActive = false;
