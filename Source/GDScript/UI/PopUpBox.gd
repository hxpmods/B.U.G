extends MarginContainer

signal OnConfirmationPressed()

func _ready():
	GameManager.SetPopUpBox(self)

func Open(var pos : Vector2, var size : Vector2, var title : String, var body = ""):
	rect_position = pos
	rect_size = size
	$Panel/HBoxContainer/VBoxContainer/TitlePanel/Title.text= title
	
	if body == "":
		$Panel/HBoxContainer/VBoxContainer/BodyPanel.visible = false
	else:
		$Panel/HBoxContainer/VBoxContainer/BodyPanel/Title.text = body
		$Panel/HBoxContainer/VBoxContainer/BodyPanel.visible = true
	visible = true;
	$"WooshAudio".Play()
	
func Close():
	visible = false;

func _input(event):
	if visible:
		if event.is_action_pressed("skip"):
			get_tree().set_input_as_handled()
			emit_signal("OnConfirmationPressed")
			
			

func _on_Button_pressed():
	$ButtonAudio.Play()
	emit_signal("OnConfirmationPressed")

