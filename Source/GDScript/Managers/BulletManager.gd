extends Node2D

var caughtEntities = []

func _ready():
	GameManager.BulletManager = self
	
func AddBullet( var bulletScene, var position : Vector2 ):
	bulletScene.position = position
	add_child(bulletScene)
