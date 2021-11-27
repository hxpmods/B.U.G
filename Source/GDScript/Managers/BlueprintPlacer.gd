extends Node2D


onready var EntityManager = get_node("../EntityManager")
onready var Buildables = get_node("../Buildables")

var active : bool = false
var canPlace : bool = false
var currentBuildable : Node = null;
var moving : bool = false

func _ready():
	GameManager.SetBlueprintPlacer(self)
	visible = false

func _draw():
	var rect = Rect2(Vector2.ZERO, Vector2(25,17)*64)
	draw_rect(rect,Color.aquamarine)

func ShowRadius(var radius):
	$"BlueprintSprite/RadiusDrawer".radius = radius
	$"BlueprintSprite/RadiusDrawer".visible =true

func HideRadius():
	$"BlueprintSprite/RadiusDrawer".visible =false
	

func StartBuild(buildableName : String):
	
	var buildable = Buildables.get_node(buildableName)
	if buildable.isUnlocked:
		active = true
		visible = true
		currentBuildable = buildable
		$BlueprintSprite.texture = currentBuildable.blueprintSprite
		GameManager.ResourceManager.PreviewCosts(currentBuildable.GetCosts(), true)
		
		if buildable.is_in_group("tower"):
			ShowRadius(buildable.buildRadius)
		

func StartMove(movable : Buildable):
	moving = true
	currentBuildable = movable
	active = true
	visible = true
	$BlueprintSprite.texture = currentBuildable.blueprintSprite
	
	GameManager.ResourceManager.PreviewCosts(currentBuildable.GetCosts(), true)
	
	if movable.is_in_group("tower"):
			ShowRadius(movable.get_parent().get_node("EntityData").GetRadius())
	
func Stop():
	GameManager.ResourceManager.ClearCosts()
	HideRadius()
	active = false
	visible =false
	moving = false
	currentBuildable = null

func _unhandled_input(event):
	if active:
		if event is InputEventMouseButton:
			if event.pressed:
				if event.button_index == 1:
					get_tree().set_input_as_handled()
					
					if canPlace and GameManager.ResourceManager.CanAffordCosts(currentBuildable.GetCosts()):
						if moving:
							MoveEntity()
							Stop()
						else:
							BuildEntity()
							
						GameManager.AudioManager.PlayPlace()
							
							
			if event.button_index == 2:
				Stop()

func BuildEntity():
	var scene = currentBuildable.sceneToBuild.instance()
	scene.position = get_global_mouse_position()
	
	var spent = true
	
	for cost in currentBuildable.GetCosts():
		var thisSpent = GameManager.ResourceManager.Spend(cost)
		spent = spent and thisSpent
	
	if spent:
		EntityManager.AddEntity(scene)
	
func MoveEntity():
	var scene = currentBuildable.get_parent()
	
	
	var spent = true
	
	for cost in currentBuildable.GetCosts():
		var thisSpent = GameManager.ResourceManager.Spend(cost)
		spent = spent and thisSpent
	
	if spent:
		scene.position = EntityManager.WorldToGrid(get_global_mouse_position())
		scene.name = str(EntityManager.WorldToMap(get_global_mouse_position()))
	
	moving = false
	

func _process(delta):
	if active: 
		var pos = get_global_mouse_position()
		pos.x = int(pos.x) /64
		pos.y = int(pos.y) /64
		$BlueprintSprite.position = pos*64
		
		canPlace = !EntityManager.HasEntityAtPos(pos)
	
	if canPlace:
		$BlueprintSprite.modulate = Color.blue
	else:
		$BlueprintSprite.modulate = Color.red
