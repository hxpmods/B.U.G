extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.SetEntityManager(self)
	ReadyEntities()


func WorldToMap(worldPos : Vector2):
	var pos = worldPos
	pos.x = int(pos.x) /64
	pos.y = int(pos.y) /64
	return pos

func Sell(sellable : Node):
	if is_instance_valid(sellable):
		var entity = sellable.get_parent()
		for cost in sellable.GetCosts():
			GameManager.ResourceManager.AddResource(cost.name, cost.amount)
		entity.queue_free()

func WorldToGrid(worldPos : Vector2):
	return WorldToMap(worldPos)* 64

func AddEntity(node : Node2D):
	var pos = node.position
	pos = WorldToMap(pos)

	node.name = str(pos)
	node.position = pos*64
	
	add_child(node)
	
	if node.has_node("Body"):
			node.get_node("Body").connect("Selected", GameManager.SelectionManager, "OnEntitySelected")
			

func HasEntityAtPos( var pos : Vector2 ):
	return has_node(str(pos))

func SetCoordNames():
		
	for child in get_children():
		var pos = child.position
		pos.x = int(pos.x) /64
		pos.y = int(pos.y) /64
		child.name = str(pos)

func ReadyEntities():
	
	SetCoordNames()
	for child in get_children():
		if child.has_node("Body"):
			child.get_node("Body").connect("Selected", GameManager.SelectionManager, "OnEntitySelected")
