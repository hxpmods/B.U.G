extends Node

func _ready():
	GameManager.DataManager.AddPeony()
	
func _exit_tree():
	GameManager.DataManager.RemovePeony()
