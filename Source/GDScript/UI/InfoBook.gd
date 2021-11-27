extends HSplitContainer

var data : Node

func _process(delta):
	if data != null:
		if is_instance_valid(data):
			$Control/TextureRect/Control/BodyText.text = data.GetDataBodyText()
			$Control/TextureRect/Control/TitleText.text = data.title
			$Control/TextureRect/EntityTexture.texture = data.GetTexture()
			
			if data.has_method("DrawThisFrame"):
				data.DrawThisFrame()
			
			
			var entity = data.get_parent()
			if entity != null:
				if is_instance_valid(entity):
					if entity.has_method("GetEntityMovable"):
						$"Control2/MarginContainer/ContextPanel/CenterContainer/VBoxContainer/BottomContext/MoveButton".visible = true
					else:
						$"Control2/MarginContainer/ContextPanel/CenterContainer/VBoxContainer/BottomContext/MoveButton".visible = false
			
					if entity.has_method("GetEntitySellable"):
						$"Control2/MarginContainer/ContextPanel/CenterContainer/VBoxContainer/BottomContext/DestroyButton".visible = true
					else:
						$"Control2/MarginContainer/ContextPanel/CenterContainer/VBoxContainer/BottomContext/DestroyButton".visible = false
	
					if entity.has_node("SkillUnlocker"):
						$"Control2/MarginContainer/ContextPanel/CenterContainer/VBoxContainer/BottomContext/UpgradeButton".visible = true
					else:
						$"Control2/MarginContainer/ContextPanel/CenterContainer/VBoxContainer/BottomContext/UpgradeButton".visible = false
	
					if entity.has_node("TargetingComponent"):
						var targeting = entity.get_node("TargetingComponent")

						var label = $"Control2/MarginContainer/ContextPanel/CenterContainer/VBoxContainer/TopContext/PriorityLabel"
						
						if targeting.targetingMode == 0:
							label.text = "Closest"
						elif targeting.targetingMode == 1:
							label.text = "Closest to Flower"
						elif targeting.targetingMode == 2:
							label.text = "Highest Health"
						
	else:
		
		$"Control2/MarginContainer/ContextPanel/CenterContainer/VBoxContainer/TopContext/PriorityLabel".text = ""
		$Control/TextureRect/Control/BodyText.text = ""
		$Control/TextureRect/Control/TitleText.text = ""


func _on_MoveButton_pressed():
	if data != null:
		if is_instance_valid(data):
			var entity = data.get_parent()
			if entity != null:
				if is_instance_valid(entity):
					if entity.has_method("GetEntityMovable"):
						GameManager.BlueprintPlacer.StartMove(entity.GetEntityMovable())
						get_parent().End()


func _on_DestroyButton_pressed():
	if data != null:
		if is_instance_valid(data):
			var entity = data.get_parent()
			if entity != null:
				if is_instance_valid(entity):
					if entity.has_method("GetEntitySellable"):
						GameManager.EntityManager.Sell(entity.GetEntitySellable())
						get_parent().End()


func _on_MoveButton_mouse_entered():
	if data != null:
		if is_instance_valid(data):
			var entity = data.get_parent()
			if entity != null:
				if is_instance_valid(entity):
					if entity.has_method("GetEntityMovable"):
						
						var buildable= entity.GetEntityMovable()
						
						if !GameManager.BlueprintPlacer.active:
							if buildable != null:
								GameManager.ResourceManager.PreviewCosts(buildable.GetCosts(), true)


func _on_MoveButton_mouse_exited():
	if !GameManager.BlueprintPlacer.active:
		GameManager.ResourceManager.ClearCosts()


func _on_DestroyButton_mouse_entered():
	if data != null:
		if is_instance_valid(data):
			var entity = data.get_parent()
			if entity != null:
				if is_instance_valid(entity):
					if entity.has_method("GetEntitySellable"):
						
						var buildable= entity.GetEntitySellable()
						
						if !GameManager.BlueprintPlacer.active:
							if buildable != null:
								GameManager.ResourceManager.PreviewCosts(buildable.GetCosts(), false)


func _on_DestroyButton_mouse_exited():
	if !GameManager.BlueprintPlacer.active:
		GameManager.ResourceManager.ClearCosts()


func UpgradeButtonPressed():
	if data != null:
		if is_instance_valid(data):
			var entity = data.get_parent()
			if entity != null:
				if is_instance_valid(entity):
					if entity.has_node("SkillUnlocker"):
						GameManager.UpgradesMenu.FollowEntity(entity)
						GameManager.UpgradesMenu.show()


func _on_UpgradeButton_toggled(button_pressed):
	if button_pressed:
		UpgradeButtonPressed()
	else:
		GameManager.UpgradesMenu.FollowEntity(null)
		GameManager.UpgradesMenu.hide()


func _on_SettingsButton_pressed():
	if data != null:
		if is_instance_valid(data):
			var entity = data.get_parent()
			if entity != null:
				if is_instance_valid(entity):
					if entity.has_node("TargetingComponent"):
						var targeting = entity.get_node("TargetingComponent")
						targeting.targetingMode = (targeting.targetingMode + 1) %3
