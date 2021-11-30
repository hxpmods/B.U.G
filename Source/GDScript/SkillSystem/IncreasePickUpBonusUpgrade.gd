extends Upgrade
class_name IncreasePickUpBonusUpgrade

export var increaseBy = 5
export(String, "harvestable", "fishable") var pickupGroup

func ApplyUpgrade(entity):
	entity.get_node("EntityData").pickUpBonuses[pickupGroup] += increaseBy
