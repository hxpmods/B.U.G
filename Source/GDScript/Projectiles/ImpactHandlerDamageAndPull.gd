extends Node2D

export var damage : int = 5
var pullingEntity = null


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
				owner.pullBackMode = true
				if !entity in GameManager.BulletManager.caughtEntities:
					pullingEntity = entity
					GameManager.BulletManager.caughtEntities.append(pullingEntity)

func _exit_tree():
	if pullingEntity != null:
		if pullingEntity in GameManager.BulletManager.caughtEntities:
			GameManager.BulletManager.caughtEntities.remove(GameManager.BulletManager.caughtEntities.find(pullingEntity))

func _physics_process(delta):
	if pullingEntity != null:
		if is_instance_valid(pullingEntity):
			if pullingEntity.is_inside_tree():
				pullingEntity.global_position = self.global_position

func SetDamage(amount):
	damage = amount
