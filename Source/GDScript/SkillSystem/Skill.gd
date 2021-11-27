extends Node
class_name Skill

export (Array, NodePath) var UnlocksSkills
export (Array, NodePath) var LocksSkills
var DependantOnSkills : Array
export (String) var humanName
export (int) var cost = 1
export (String, MULTILINE) var description
export (bool) var isRoot = false

func GetSkillsToUnlock():
	var skills = []
	for path in UnlocksSkills:
		skills.append(get_node(path))
	return skills

func SetDependencies():
	for skillPath in UnlocksSkills:
		var skill = get_node(skillPath)
		skill.DependantOnSkills.append(name)

func _ready():
	SetDependencies()

func LearnSkill(var entity):
	for child in get_children():
		child.ApplyUpgrade(entity)
