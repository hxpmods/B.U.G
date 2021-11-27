extends Node
class_name Buildable

export var sceneToBuild : PackedScene
export var blueprintSprite : Texture
export var isUnlocked = false
export var buildRadius : float = 0

export var humanName : String
export(String, MULTILINE) var description : String

signal OnUnlockStateChanged(isUnlocked)

func SetUnlocked( unlocked: bool):
	isUnlocked = unlocked
	emit_signal("OnUnlockStateChanged", unlocked)

func GetCosts():
	var costs :Array
	
	for children in get_children():
		if children.get_class() == "Currency":
			costs.append(children)
			
	return costs
