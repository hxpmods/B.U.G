extends Upgrade
class_name IncreaseRangedSpeedUpgrade

export var increaseBy = 0.1

func ApplyUpgrade(entity):
	var controller = entity.get_node("RangedShootingController")
	controller.SetShootSpeed(controller.shootSpeed + increaseBy)
