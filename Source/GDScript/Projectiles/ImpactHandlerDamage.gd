extends Node2D

export var damage : int = 5

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
	
func SetDamage(amount):
	damage = amount
