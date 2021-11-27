extends "res://Source/GDScript/Projectiles/HomingProjectile.gd"

func _process(delta):
	if !is_instance_valid(target) or !target.is_inside_tree():
		Die()
	update()
	
func _draw():
	draw_line(Vector2.ZERO,(shooter.global_position - self.global_position).rotated(-rotation), Color.black,2)

