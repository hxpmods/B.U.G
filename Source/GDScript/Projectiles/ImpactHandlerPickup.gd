extends Node2D

export var pickupGroup = "harvestable"

func handle_impact(target : Node2D):
	var entity = target.GetEntity()
	if entity.is_in_group(pickupGroup):
		owner.shooter.emit_signal("ProjectileKilledEntity", entity)
		entity.PickUp()
