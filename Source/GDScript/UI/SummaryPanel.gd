extends Panel

var currentBuildable : Buildable

func SetBuildable(var buildable):
	currentBuildable = buildable
	if currentBuildable.isUnlocked:
		$Control/JobTitle.text = currentBuildable.humanName
		$Control/InfoText.text = currentBuildable.description
	else:
		$Control/JobTitle.text = "???"
		$Control/InfoText.text = "??????"

func _ready():
	SetBuildable(GameManager.Buildables.get_child(0))
