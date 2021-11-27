extends TextureRect

var shopItem
signal Selected( textureRect)

func SetShopItem( var item : ShopItem):
	shopItem = item
	$PotRect.visible = item.usePlantPot
	texture = item.texture


func _on_TextureRect_gui_input(event):
		if event is InputEventMouseButton:
			if event.pressed:
				if event.button_index == 1:
					emit_signal("Selected",self)
					get_tree().set_input_as_handled()
