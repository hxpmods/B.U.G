extends Panel

export var labelScene : PackedScene

func _ready():
	for child in GameManager.ResourceManager.get_children():
		var label =labelScene.instance()
		child.connect("OnAmountChanged",label,"AmountChanged")
		child.connect("OnPreviewAmountChanged", label, "SetPreview")
		label.AmountChanged(child.amount)
		label.SetTexture(child.texture)
		$ResourceGrid.add_child(label)
