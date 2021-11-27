extends ShopItem
class_name SeedShopItem

export var seedToPurchase : String
export var amount : int

func Purchase():
	if GameManager.ResourceManager.CanAffordCosts(GetCosts()):
		for cost in GetCosts():
			GameManager.ResourceManager.Spend(cost)
		
		var profits = GetProfits()[0]
		GameManager.ResourceManager.AddResource(profits.name, profits.amount)

func get_class():
	return "SeedShopItem"

func GetProfits():
	var currency = Currency.new()
	currency.name = humanName
	currency.amount = amount
	return [currency]
