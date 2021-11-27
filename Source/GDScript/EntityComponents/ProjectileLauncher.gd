extends Node2D

var activeProjectiles : Array
export var projectileDamage = 5


signal ProjectileKilledEntity(entity)

func Shoot(var bulletScene, var target : Node2D):
	var bullet = bulletScene.instance()
	bullet.SetShooter(self)
	bullet.SetTarget(target)
	
	if bullet.has_node("ImpactHandler"):
		var impactHandler = bullet.get_node("ImpactHandler")
		if impactHandler.has_method("SetDamage"):
			impactHandler.SetDamage(projectileDamage)
		
	activeProjectiles.append(bullet)
	GameManager.BulletManager.AddBullet(bullet,global_position)
	return bullet

func RemoveFromActiveProjectiles(bullet):
	if bullet in activeProjectiles:
		activeProjectiles.remove(activeProjectiles.find(bullet))
