extends Node2D

var title : String
export var job: String
var totalKills : int = 0
var totalHarvests: int = 0
var level : int = 1

var skillPoints : int = 0

var doDraw = false

var pickUpBonuses = {"harvestable" : 0, "fishable" : 0}

signal OnSkillPointsUpdated(amount)

func SetSkillPoints(var amount):
	skillPoints = amount
	emit_signal("OnSkillPointsUpdated", amount)
	
	if get_parent().has_node("SkillUnlocker"):
		var skillUnlocker = get_parent().get_node("SkillUnlocker")
		$UpgradeDisplay.visible = skillUnlocker.CanUnlockAnySkills(amount)
	
func GetPickUpBonus(pickupGroup):
	return pickUpBonuses[pickupGroup]
	
func KilledEntity(var entity):
	if entity.is_in_group("enemy"):
		totalKills += 1
	else:
		totalHarvests += 1
		
	if GetKillsToNextLevel() < 1:
		SetSkillPoints(skillPoints+1)
		level += 1

func GetKillsToNextLevel():
	return (NextLevel(level))- (totalKills+totalHarvests)

func NextLevel(level):
	var exponent = 2.5
	var baseXP = 3
	var baseLevel = 1
	return floor(baseXP * (pow(level+baseLevel,  exponent)))


func _ready():
	title = GetRandomName()

func GetRandomName():
	var names = ["Melvin", "Wendy", "Simon", "Ronald", "Harper", "Dave", "Clark", "Bruce", "Darren", "Wally", "Helena", "Diana", "Pamela", "Arthur", "Tim", "Laurel", "Simone", "Gnarls", "Jessica", "Felicia"]
	var value = names[randi()%names.size()]
	return value

func GetDataBodyText():
	return "Profession:\n\t%s\nKill Amount:\n\t%s\nHarvest Amount:\n\t%s\nTo Next Skill:\n\t%s\nSkill Points:\n\t%s\n" % [job, totalKills, totalHarvests,GetKillsToNextLevel(), skillPoints]

func GetTexture():
	return get_parent().texture

func GetRadius():
	return $"../TargetArea/CollisionShape2D".shape.radius

func DrawThisFrame():
	doDraw = true

func _process(delta):
	update()
	doDraw = false
	
func _draw():
	if doDraw:
		var col = Color.blue
		col.a = 0.2
		draw_circle(Vector2.ZERO, GetRadius(),col)

func CanSpendSkillPoints(amount):
	return !(amount>skillPoints)
	
func SpendSkillPoints(amount):
	if CanSpendSkillPoints(amount):
		SetSkillPoints( skillPoints - amount)
