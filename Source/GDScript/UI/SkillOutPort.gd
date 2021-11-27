extends Control

var connections = []

func SetConnections(var connections):
	self.connections = connections
	update()

func _draw():
	for connection in connections:
		var inPort = connection.get_node("HBoxContainer/MarginContainerIn/InPort")
		draw_line(Vector2.ZERO, inPort.rect_global_position - rect_global_position, Color.black, 3.0,true)

func _process(delta):
	update()
