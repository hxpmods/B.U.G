extends Upgrade
class_name IncreaseMeleeSpeedUpgrade

export var increaseBy = 0.1

func ApplyUpgrade(entity):
	var controller = entity.get_node("MeleeShootingController")
	controller.SetShootSpeed(controller.shootSpeed + increaseBy)
