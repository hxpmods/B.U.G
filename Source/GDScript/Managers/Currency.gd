extends Node
class_name Currency

export var amount : int = 0
export var texture : Texture

signal OnAmountChanged(amount)
signal OnPreviewAmountChanged(amount)

func _ready():
	emit_signal("OnAmountChanged", amount)

func IsSameType(other : Currency):
	return self.name == other.name
	
func SetAmount(newAmount: int):
	amount = newAmount
	emit_signal("OnAmountChanged", amount)

func get_class():
	return "Currency"
	
