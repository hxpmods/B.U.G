extends WaveAction
class_name TutorialWaveAction


enum GIGnomeDisplayMode {NONE, RIGHT, LEFT}

export var title : String
export(String, MULTILINE) var text: String
export var popupPos : Vector2
export var popupSize : Vector2
export(int, "None", "Right", "Left") var showGIGnome = GIGnomeDisplayMode.NONE

var finished = false

func IsCompleted():
	return finished

func Start():
	.Start()
	GameManager.SetGameState(GameManager.GameState.TUTORIALPAUSED)
	GameManager.PopUpBox.Open(popupPos, popupSize,title,text)
	GameManager.PopUpBox.connect("OnConfirmationPressed", self,"Finish")
	
	if showGIGnome == GIGnomeDisplayMode.RIGHT:
		$"../../../CanvasLayer/Screen/GiGnomeRight".visible = true
	elif showGIGnome == GIGnomeDisplayMode.LEFT:
		$"../../../CanvasLayer/Screen/GiGnomeLeft".visible = true
		
func Finish():
	finished = true
	$"../../../CanvasLayer/Screen/GiGnomeLeft".visible = false
	$"../../../CanvasLayer/Screen/GiGnomeRight".visible = false
	GameManager.PopUpBox.disconnect("OnConfirmationPressed", self,"Finish")
	GameManager.PopUpBox.Close()
	GameManager.SetGameState(GameManager.GameState.PLAYING)
	
