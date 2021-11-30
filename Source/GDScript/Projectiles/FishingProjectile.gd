extends Projectile

var pullBackMode = false
var hasHit = false

func _physics_process(delta):
	if target:
		if !is_instance_valid(target) or !target.is_inside_tree():
			Die()
		
		if is_instance_valid(target) and target.is_inside_tree():
			look_at(target.global_position)
	update()
	
	if useLifetime:
		lifeTime -= delta
	if lifeTime <= 0:
		Die()
	
	if !deathQueued:
		
		if !pullBackMode:
			position += transform.x * maxSpeed * delta
		else:
			position += self.global_position.direction_to(shooter.global_position) * maxSpeed * delta
			
			if global_position.distance_to(shooter.global_position) < 1:
				Die()
		if !useCustomRange and is_instance_valid(shooter):
			if global_position.distance_to(shooter.global_position) > shooter.get_parent().get_node("EntityData").GetRadius():
				Die()
		else:
			if global_position.distance_to(shooter.global_position) > customRange:
				Die()
				
		var colliding = CheckCollision()
		if colliding.size() > 0 and !hasHit:
			if impactHandler != null:
				for collider in colliding:
					if !hasHit and collider["collider"].GetEntity() == target:
						impactHandler.handle_impact(collider["collider"])
						hasHit = true

	
func _draw():
	draw_line(Vector2.ZERO,(shooter.global_position - self.global_position).rotated(-rotation), Color.black,2)

func get_class():
	return "FishingProjectile"
