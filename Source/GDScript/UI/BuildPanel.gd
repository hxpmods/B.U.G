extends Panel

onready var buildables = GameManager.Buildables
onready var blueprintPlacer = GameManager.BlueprintPlacer
export var buttonScene : PackedScene
var buttons : Array

func _ready():
	
	var id = 0;
	
	for buildable in buildables.get_children():
		
		var button = buttonScene.instance();
		
		if buildable.is_in_group("tower"):
			$"VBoxContainer/TowerCenterContainer/GridContainer".add_child(button)
		if buildable.is_in_group("flower"):
			$"VBoxContainer/FlowerCenterContainer/GridContainer".add_child(button)
		
		buttons.append(button)
		button.set_owner(self)
		button.set_buildable(buildable)
		button.connect("OnStartBlueprintPlacer", self, "AttemptBuild")
		button.connect("OnBuildableHovered", get_parent().find_node("SummaryPanel"), "SetBuildable")
		button.connect("OnEndBlueprintPlacer", self, "CancelBuild")

func ResetOtherButtons(button):
	for otherButton in buttons:
		if otherButton != button: otherButton.pressed = false

func AttemptBuild(buildable : Buildable):
	blueprintPlacer.StartBuild(buildable.name)

func CancelBuild():
	blueprintPlacer.Stop()

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			if event.button_index == 2:
				for button in buttons:
					button.pressed = false
