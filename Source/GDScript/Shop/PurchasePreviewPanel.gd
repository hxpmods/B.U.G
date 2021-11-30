extends Panel

var preview

func SetPreview(var shopItem : ShopItem):
	
	if shopItem != null:
		
		if preview != shopItem:
			preview = shopItem
			GameManager.ResourceManager.ClearCosts()
			
			$"../../..".visible = true
			
			$"VBoxContainer/NameLabel".text = shopItem.humanName
			
			if shopItem.get_class() == "SeedShopItem":
				$"VBoxContainer/QuantityLabel".visible = true
				$"VBoxContainer/QuantityLabel".text = "Quantity: " + str(shopItem.amount)
			else:
				$"VBoxContainer/QuantityLabel".visible = false
			
			$"VBoxContainer/CenterContainer/Control".texture = shopItem.texture
			
			if shopItem.has_method("GetProfits"):
				var costs = preview.GetCosts()
				var invCosts = []
				for cost in costs:
					var curr = Currency.new()
					curr.name = cost.name
					curr.amount = -cost.amount
					invCosts.append(curr)
				GameManager.ResourceManager.PreviewCosts(shopItem.GetProfits()+invCosts,false)
			else:	
				GameManager.ResourceManager.PreviewCosts(preview.GetCosts(), true)
	
	else:
		$"../../..".visible = false
	
func _process(delta):
	if preview != null:
		if is_instance_valid(preview):
			$VBoxContainer/MarginContainer/PurchaseButton.disabled = !GameManager.ResourceManager.CanAffordCosts(preview.GetCosts())


func _on_PurchaseButton_pressed():
		if preview != null:
			if is_instance_valid(preview):
				preview.Purchase()
