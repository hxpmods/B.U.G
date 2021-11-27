extends Node2D
class_name Projectile

var target : Node2D
var shooter : Node2D
export var maxSpeed : float = 100
export(int, LAYERS_2D_PHYSICS) var collisionMask
export var useCustomRange = false
export var customRange = 512

export var useLifetime = false
export var lifeTime = 5.0

onready var world2d = $"/root".find_world_2d()
onready var space = world2d.direct_space_state
export var impactHandlerPath : NodePath
onready var impactHandler = get_node(impactHandlerPath)

var deathQueued = false

func SetTarget(var target):
	self.target = target

func SetShooter(var shooter):
	self.shooter = shooter
	
func _enter_tree():
	if target:
		look_at(target.global_position)

func _physics_process(delta):
	
	if useLifetime:
		lifeTime -= delta
		if lifeTime <= 0:
			Die()
	
	if !deathQueued:
		position += transform.x * maxSpeed * delta
		if !useCustomRange and is_instance_valid(shooter):
			if global_position.distance_to(shooter.global_position) > shooter.get_parent().get_node("EntityData").GetRadius():
				Die()
		else:
			if global_position.distance_to(shooter.global_position) > customRange:
				Die()
				
		var colliding = CheckCollision()
		if colliding.size() > 0:
			if impactHandler != null:
				for collider in colliding:
					impactHandler.handle_impact(collider["collider"])
			Die()
		
func Die():
	deathQueued = true
	self.shooter.RemoveFromActiveProjectiles(self)
	self.queue_free()

func CheckCollision():
	var results = space.intersect_point(global_position, 32, [], collisionMask, true, true )
	return results

