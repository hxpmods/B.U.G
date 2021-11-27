extends Area2D

signal Selected(entity)

func _on_Body_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			if event.button_index == 1:
				emit_signal("Selected",get_parent())
				get_tree().set_input_as_handled()

func GetEntity():
	return get_parent()
