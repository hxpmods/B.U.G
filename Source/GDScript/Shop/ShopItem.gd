extends Node
class_name ShopItem

export var humanName : String
export var texture : Texture
export var usePlantPot = true

func GetCosts():
	var costs :Array
	
	for children in get_children():
		if children.get_class() == "Currency":
			costs.append(children)
			
	return costs

func Purchase():
	if GameManager.ResourceManager.CanAffordCosts(GetCosts()):
		pass
