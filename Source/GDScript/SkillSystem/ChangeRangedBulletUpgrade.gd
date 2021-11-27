extends Upgrade
class_name ChangeRangedBulletUpgrade

export var bulletScene: PackedScene

func ApplyUpgrade(entity):
	var controller = entity.get_node("RangedShootingController")
	controller.bulletScene = bulletScene
