extends ShopItem
class_name ConvertCurrencyShopItem

export var currencyToConvertTo : String
export var currencyToConvertFrom : String
export var rate : float = 1.0

func Purchase():
	if GameManager.ResourceManager.CanAffordCosts(GetCosts()):
		var profits = GetProfits()[0]
		for cost in GetCosts():
			GameManager.ResourceManager.Spend(cost)
		GameManager.ResourceManager.AddResource(profits.name, profits.amount)

func GetProfits():
	var currency = Currency.new()
	currency.name = currencyToConvertTo
	currency.amount = floor(GetCosts()[0].amount*rate)
	return [currency]

func GetCosts():
	var currency = Currency.new()
	currency.name = currencyToConvertFrom
	currency.amount = GameManager.ResourceManager.get_node(currencyToConvertFrom).amount
	return [currency]

func get_class():
	return "ConvertCurrencyShopItem"
