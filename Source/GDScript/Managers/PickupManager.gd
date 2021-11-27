extends Node2D

export var pickUpScene : PackedScene 

func _ready():
	GameManager.SetPickupManager(self);

func CreateFromCurrency( var curr : Currency , var _position : Vector2):
	var pickup = pickUpScene.instance()
	pickup.SetResource(curr)
	pickup.global_position = _position + Vector2((randf() -0.5)*64,(randf() -0.5)*64);
	add_child(pickup)
	return pickup
