extends MarginContainer

signal OnSkillBoxAdded(skillBox)
signal TreeUpdated(skillBoxes)

var followingEntity = null
var selectedSkillBox

var skillBoxes = []

var currentSkillTree

export var rowScene : PackedScene
export var skillBoxScene : PackedScene

export var skillCollumnsPath : NodePath
onready var skillCollumns = get_node(skillCollumnsPath)

func show():
	emit_signal("TreeUpdated",skillBoxes)
	.show()

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			if event.button_index == 2:
				hide()
				FollowEntity(null)
				

func _ready():
	GameManager.SetUpgradesMenu(self)

func FollowEntity(var entity):
			
	if entity != followingEntity:
		if followingEntity != null:
			followingEntity.get_node("SkillUnlocker").disconnect("SkillsUpdated",self,"LoadSkillState")
			followingEntity.get_node("EntityData").disconnect("OnSkillPointsUpdated", self, "UpdateSkillPointLabel")
		if entity == null:
			followingEntity = null
			return
		
		if !entity.has_node("SkillUnlocker"):
			return
		
		entity.get_node("EntityData").connect("OnSkillPointsUpdated", self, "UpdateSkillPointLabel")
		UpdateSkillPointLabel(entity.get_node("EntityData").skillPoints)
		var skillUnlocker = entity.get_node("SkillUnlocker")
		followingEntity = entity
		skillUnlocker.connect("SkillsUpdated",self,"LoadSkillState")
		
		SetSkillTree(skillUnlocker.skillTree)
		LoadSkillState(skillUnlocker.unlockedSkills)

func UpdateSkillPointLabel(amount):
	$"Panel/Panel/VBoxContainer/MarginContainer/Control/MarginContainer/Panel/HBoxContainer/Panel/Label".text = "Skill points: " + str(amount)

func LoadSkillState(var skillState):
	for skillBox in skillBoxes:
		
		skillBox.SetSelected(false)
		skillBox.SetBought(false)
		skillBox.SetDisabled(true)
	
	for skillBox in skillBoxes:	
		if skillBox.skill.isRoot == true:
			skillBox.SetDisabled(false)
			
		for skillName in skillState:
			if skillBox.skill.name == skillName:
				skillBox.SetBought(true)
				for unlockableSkill in skillBox.skill.GetSkillsToUnlock():
					for _skillBox in skillBoxes:
						if _skillBox.skill == unlockableSkill:
							_skillBox.SetDisabled(false)

func SetSkillTree( var skillTree):
	if currentSkillTree != skillTree:
		ClearTree()
		currentSkillTree =skillTree
		var roots = skillTree.GetTreeRoots()
		for root in roots:
			IterateThroughTree(1, [root])
		emit_signal("TreeUpdated",skillBoxes)

func ClearTree():
	skillBoxes = []
	selectedSkillBox = null
	for child in $"Panel/Panel/VBoxContainer/SkillCollumns".get_children():
		child.get_parent().remove_child(child)
		child.queue_free()
		

func OnSkillBoxSelected(var skillBox):
	selectedSkillBox = skillBox
	
	for otherSkillBox in skillBoxes:
		if otherSkillBox != skillBox:
			otherSkillBox.SetSelected(false)
			
	if followingEntity != null:
		$"Panel/Panel/VBoxContainer/MarginContainer/Control/MarginContainer/Panel/HBoxContainer/Panel2/Button".disabled= !followingEntity.get_node("EntityData").CanSpendSkillPoints(selectedSkillBox.skill.cost) or !currentSkillTree.CanUnlockSkill(selectedSkillBox.skill.name,followingEntity.get_node("SkillUnlocker").unlockedSkills)
	
func IterateThroughTree(var currentRowID : int, var currentItems):
	
	var nextRow = []
	
	for item in currentItems:
		AddToRowOrCreate(currentRowID, item)
		var subNextRow = []
		for skill in item.UnlocksSkills:
			subNextRow.append(item.get_node(skill))
		nextRow += subNextRow
	
	if nextRow.size() > 0:
		IterateThroughTree(currentRowID +1, nextRow)

func AddToRowOrCreate(rowId, skill):	
	var skillScene =skillBoxScene.instance()
	skillScene.SetSkill(skill)
	if !skillCollumns.has_node("SkillRow"+str(rowId)):
		var row = rowScene.instance()
		row.name = "SkillRow"+str(rowId)
		skillCollumns.add_child(row)
	

	skillScene.connect("Selected", self, "OnSkillBoxSelected")
	self.connect("TreeUpdated",skillScene,"OnTreeUpdated")
	skillCollumns.get_node("SkillRow"+str(rowId)).add_child(skillScene)
	
	
	skillBoxes.append(skillScene)
	emit_signal("OnSkillBoxAdded", skillScene)


func _on_UpgradeButton_pressed():
	if followingEntity != null:
		if selectedSkillBox != null:
			if is_instance_valid(selectedSkillBox):
				if followingEntity.has_node("SkillUnlocker"):
					var unlocker = followingEntity.get_node("SkillUnlocker")
					unlocker.AddSkill(selectedSkillBox.skill.name)
