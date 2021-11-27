extends Panel

var skill : Skill
var connections : Array = []

var selected = false
var disabled = false
var bought = false

signal Selected(skillBox)

func _ready():
	material = material.duplicate()

func SetSkill(_skill):
	skill = _skill
	$HBoxContainer/VBoxContainer/NameLabel.text = skill.humanName +"\n Cost: " +str(skill.cost)
	$"HBoxContainer/VBoxContainer/MarginContainer/MarginContainer/Panel/MarginContainer/BodyTextLabel".text = skill.description


func OnTreeUpdated(skillBoxes):
	for skillBox in skillBoxes:
		if skillBox != self:
			OnOtherSkillBoxAdded(skillBox)


func OnOtherSkillBoxAdded( skillBox):
	if skillBox.skill in skill.GetSkillsToUnlock():
		connections.append(skillBox)
		UpdateVisualConnections(connections)

func SetSelected( var selected):
	self.selected = selected
	material.set_shader_param("isSelected", selected)

func SetBought( var bought):
	self.bought = bought
	material.set_shader_param("isBought", bought)

func SetDisabled( var disabled):
	self.disabled = disabled
	material.set_shader_param("isDisabled", disabled)

func UpdateVisualConnections(connections):
	$"HBoxContainer/MarginContainerOut/OutPort".SetConnections(connections)



func _on_SkillBox_gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			if event.button_index == 1:
				SetSelected(!selected)
				emit_signal("Selected", self)
