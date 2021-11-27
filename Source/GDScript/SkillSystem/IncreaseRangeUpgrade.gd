extends Upgrade
class_name IncreaseRangeUpgrade

export var increaseBy = 16

func ApplyUpgrade(entity):
	entity.get_node("TargetArea/CollisionShape2D").shape.radius += increaseBy
