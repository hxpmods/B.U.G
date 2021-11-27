extends Control

export var gameScene: PackedScene
var gameInstance

func _ready():
	GameManager.MainMenu = self
	
func _enter_tree():
	gameInstance = gameScene.instance()

func _on_Button_pressed():
	get_tree().get_root().add_child(gameInstance)
	get_tree().get_root().remove_child(self.get_parent())

