extends Button

var isUnlocked: bool = false
var unlockColor = Color.white
var lockColor = Color(0.4,0.4,0.4)
var buildable : Buildable


signal OnStartBlueprintPlacer(buildable)
signal OnBuildableHovered(buildable)
signal OnEndBlueprintPlacer()

func _ready():
	SetUnlocked( false)

func SetUnlocked( unlocked: bool):
	isUnlocked = unlocked
	if isUnlocked:
		modulate = unlockColor
	else:
		modulate = lockColor

func set_buildable(_buildable : Buildable):
	self.buildable = _buildable
	$TextureRect.texture = _buildable.blueprintSprite
	SetUnlocked(_buildable.isUnlocked)
	_buildable.connect("OnUnlockStateChanged", self, "SetUnlocked")

func _on_Panel_toggled(button_pressed):
	if button_pressed:
		owner.ResetOtherButtons(self)
		emit_signal("OnStartBlueprintPlacer", buildable)
	else:
		emit_signal("OnEndBlueprintPlacer")


func _on_Panel_mouse_entered():
	emit_signal("OnBuildableHovered", buildable)
	if !GameManager.BlueprintPlacer.active:
		GameManager.ResourceManager.PreviewCosts(buildable.GetCosts(), true)
	
	

func _on_Panel_mouse_exited():
	if !GameManager.BlueprintPlacer.active:
		GameManager.ResourceManager.ClearCosts()
