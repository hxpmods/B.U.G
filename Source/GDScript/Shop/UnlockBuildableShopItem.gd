extends ShopItem
class_name UnlockBuildableShopItem

export var buildableToUnlock : String

func Purchase():
	if GameManager.ResourceManager.CanAffordCosts(GetCosts()):
		for cost in GetCosts():
			GameManager.ResourceManager.Spend(cost)
		GameManager.Buildables.get_node(buildableToUnlock).SetUnlocked(true)
		owner.RemoveItem(self)

func get_class():
	return "UnlockBuildableShopItem"
