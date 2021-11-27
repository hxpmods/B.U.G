extends Node

export var intensity : float = 1 setget setIntensity


func setIntensity(amount):
	intensity = amount;
	for child in get_children():
		child.setIntensity(amount)


func _process(delta):
	setIntensity(min(get_node("../AntManager").get_child_count()/100.0, 1.0))
