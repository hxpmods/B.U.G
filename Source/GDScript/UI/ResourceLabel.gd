extends HBoxContainer

func AmountChanged(amount):
	$ValueLabel.text= str(amount)

func SetTexture(texture):
	$ResourceImage.texture = texture
