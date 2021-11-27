extends Sprite

func GetBody():
	return get_node("Body")

func GetEntityMovable():
	return get_node("Movable")

func GetEntitySellable():
	return get_node("Sellable")

func _ready():
	$"TargetArea/CollisionShape2D".shape = $"TargetArea/CollisionShape2D".shape.duplicate()

func GetEntityData():
	return $"EntityData"
