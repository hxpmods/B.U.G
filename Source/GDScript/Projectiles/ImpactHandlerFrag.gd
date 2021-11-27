extends Node2D

export var damage : int = 5
export var shrapnelScene : PackedScene 
export var shrapnelAmount : int = 4
export var spread : float = 1.0

func handle_impact(target : Node2D):
	var entity = target.GetEntity()
	if entity.is_in_group("enemy"):
		if entity.health >0:
			var lethal = entity.Damage(damage)
			if lethal:
				owner.shooter.emit_signal("ProjectileKilledEntity", entity)
				GameManager.AudioManager.PlaySplat()
			else:
				GameManager.AudioManager.PlaySquelch()
			DoShrapnel()
	
func SetDamage(amount):
	damage = amount

func DoShrapnel():
	for i in range(shrapnelAmount):
		var shrap : Node2D = shrapnelScene.instance()
		shrap.SetShooter(owner.shooter)
		shrap.global_rotation = self.global_rotation
		shrap.rotation+= rand_range(-PI*spread,PI*spread)
		GameManager.BulletManager.AddBullet(shrap,global_position)
