extends AnimatedSprite

export var growthProgress = 0;
export var timeToFullyGrow = 60.0;
export var maxHealth = 100
onready var health = maxHealth
var canHarvest = false;


func Damage(amount):
	health = clamp(health- amount, 0, maxHealth)
	material.set_shader_param("satAmount" , health/maxHealth)
	
	
	GameManager.AudioManager.PlayDamage()
	if health == 0:
		Die()

func _ready():
	material = material.duplicate()
	var maxFrames = frames.get_frame_count("default")
	frame = int(growthProgress/ (100.0/maxFrames))

func Die():
	queue_free()

func GetBody():
	return get_node("Body")

func IncreaseGrowthProgress(amount : float):
	if health == maxHealth:
	
		growthProgress = clamp(growthProgress+amount,0,100)
		if growthProgress == 100: Harvest()
		var maxFrames = frames.get_frame_count("default")

		frame = int(growthProgress/ (100.0/maxFrames))
	
	else:
		health = clamp(health+amount,0,maxHealth)
		material.set_shader_param("satAmount", health/maxHealth)
		
func _process(delta):
	IncreaseGrowthProgress(delta*(100/timeToFullyGrow))

func Harvest():
	var curr = Currency.new()
	curr.name = $Harvestable.get_child(0).name
	curr.amount = $Harvestable.get_child(0).amount
	GameManager.PickupManager.CreateFromCurrency(curr, global_position)
	growthProgress = 0

func GetEntitySellable():
	return get_node("Sellable")
