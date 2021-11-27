extends Projectile

func _physics_process(delta):
	if target:
		if is_instance_valid(target) and target.is_inside_tree():
			look_at(target.global_position)
	update()
	._physics_process(delta)
	

