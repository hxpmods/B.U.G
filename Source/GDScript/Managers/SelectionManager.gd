extends Node2D


var selectedObject: Node2D

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			if event.button_index == 2:
				selectedObject = null
				get_node("../CanvasLayer/Screen/MarginContainer/BottomControl").End()

func _ready():
	GameManager.SetSelectionManager(self)

func OnEntitySelected(entity):
	if entity!= null:
		if selectedObject != entity:
			selectedObject = entity	
			var entityData = entity.find_node("EntityData")
			if entityData != null:
				get_node("../CanvasLayer/Screen/MarginContainer/BottomControl").Start(entityData)
		else:
			selectedObject = null
			get_node("../CanvasLayer/Screen/MarginContainer/BottomControl").End()
