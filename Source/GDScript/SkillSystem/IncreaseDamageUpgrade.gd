extends Upgrade
class_name IncreaseDamageUpgrade

export var increaseBy = 5


func ApplyUpgrade(entity):
	entity.get_node("ProjectileLauncher").projectileDamage += increaseBy
