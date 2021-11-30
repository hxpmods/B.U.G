extends Upgrade
class_name AddMeleeBulletCostUpgrade

export var currency : String
export var amount : int = 1

func ApplyUpgrade(entity):
	var controller = entity.get_node("MeleeShootingController")
	CreateOrApplyCostUpdate(currency, amount, controller)

func CreateOrApplyCostUpdate(currency, amount, controller):
	if controller.has_node(currency):
		controller.get_node(currency).amount += amount
	else:
		var curr = Currency.new()
		curr.name = currency
		curr.amount = amount
		controller.add_child(curr)
