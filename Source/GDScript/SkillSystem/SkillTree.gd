extends Node

func GetTreeRoots():
	var results = []
	for child in get_children():
		if child.isRoot:
			results.append(child)
	return results

func GetSkill(var name):
	return get_node(name)

func CanUnlockSkill(var skillName, var currentUnlockedSkills):
	
	if skillName in currentUnlockedSkills:
		return false
	
	var skill = GetSkill(skillName)
	var dependenciesToSolve = skill.DependantOnSkills.size()
	
	for unlockedSkill in currentUnlockedSkills:
		for dependantSkill in skill.DependantOnSkills:
			if dependantSkill == unlockedSkill:
				dependenciesToSolve -= 1
			
	return dependenciesToSolve == 0
	
