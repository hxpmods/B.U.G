extends Node
class_name SkullUnlocker

export var skillTreeName : String
export var entityDataPath : NodePath
onready var entityData = get_node(entityDataPath)
onready var skillTree = GameManager.SkillsManager.get_node(skillTreeName)
export(Array, String) var unlockedSkills 

signal SkillsUpdated()

func AddSkill(var name):
	if skillTree.CanUnlockSkill(name, unlockedSkills):
		var skill = skillTree.GetSkill(name)
		if entityData.CanSpendSkillPoints(skill.cost):
			entityData.SpendSkillPoints(skill.cost)
			unlockedSkills.append(name)
			emit_signal("SkillsUpdated",unlockedSkills)
			skill.LearnSkill(get_parent())

func CanUnlockAnySkills(var skillPoints):
	
	var result = false
	for skill in skillTree.get_children():
		if skillTree.CanUnlockSkill(skill.name, unlockedSkills):
			if !skill.cost>skillPoints:
				result = true
				
	return result
