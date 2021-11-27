extends HBoxContainer


func AmountChanged(amount):
	$ResourceLabel.AmountChanged(amount)

func SetTexture(texture):
	$ResourceLabel.SetTexture(texture)

func SetPreview(amount : int):
	if amount == 0:
		$PreviewLabel.text = ""
		return
	
	var labelText= str(amount)
	
	if amount > 0:
		SetPreviewColor(Color.green)
		labelText= "+"+labelText
	else:
		SetPreviewColor(Color.red)
	$PreviewLabel.text = str(labelText)

func SetPreviewColor( var col : Color):
	$PreviewLabel.add_color_override("font_color", col)
