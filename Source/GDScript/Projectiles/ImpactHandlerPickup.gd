extends Node2D

export var pickupGroup = "harvestable"

func handle_impact(target : Node2D):
	var entity = target.GetEntity()
	if entity.is_in_group(pickupGroup):
		owner.shooter.emit_signal("ProjectileKilledEntity", entity)
		
		var bonus = 0
		
		if owner.shooter.owner.has_node("EntityData"):
			var data = owner.shooter.owner.find_node("EntityData")
			bonus = data.GetPickUpBonus(pickupGroup)
		
		entity.PickUp(bonus)
