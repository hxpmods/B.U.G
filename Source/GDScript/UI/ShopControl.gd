extends MarginContainer


export var shopItemIconInstance : PackedScene 

onready var shopRow1 = get_node("Panel/Panel/TextureRect/MarginContainer/VBoxContainer/ShopRow1")
onready var shopRow2 = get_node("Panel/Panel/TextureRect/MarginContainer/VBoxContainer/ShopRow2")
onready var shopRow3 = get_node("Panel/Panel/TextureRect/MarginContainer/VBoxContainer/ShopRow3")

onready var inventory = get_node("Inventory")

func _ready():
	
	GameManager.SetShop(self)
	
	for item in inventory.get_children():
		if item.get_class() == "SeedShopItem":
			AddItemToRow(item, shopRow1)
		elif item.get_class() == "UnlockBuildableShopItem":
			AddItemToRow(item, shopRow2)
		else:
			AddItemToRow(item, shopRow3)

func RemoveItem( item : ShopItem):
	
	var itemIcon;
	
	var icons = shopRow1.get_children() + shopRow2.get_children()
	
	for icon in icons:
		if icon.shopItem == item:
			itemIcon = icon
	
	if $"Panel/Panel/MarginContainer/Panel/MarginContainer/PurchasePreviewPanel".preview == itemIcon:
		$"Panel/Panel/MarginContainer/Panel/MarginContainer/PurchasePreviewPanel".SetPreview(null)	
	item.queue_free()
	itemIcon.get_parent().remove_child(itemIcon)
	itemIcon.queue_free()
	

func AddItemToRow(item, row):
	var icon = shopItemIconInstance.instance()
	icon.SetShopItem(item)
	icon.connect("Selected", self, "OnShopItemSelected")
	row.add_child(icon)

func OnShopItemSelected(var shopItemIcon):
	$"Panel/Panel/MarginContainer/Panel/MarginContainer/PurchasePreviewPanel".SetPreview(shopItemIcon.shopItem)
