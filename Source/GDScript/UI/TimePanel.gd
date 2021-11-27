extends Panel

var dayCounterBaseText : String
var infoBaseText : String

func _ready():
	GameManager.connect("OnGameStateChanged", self, "OnGameStateChanged")
	OnGameStateChanged(GameManager.gameState)

func _on_DataManager_OnDayChanged(newDay):
	if !dayCounterBaseText:
		dayCounterBaseText = get_node("VBoxContainer/DayCounter").text
	get_node("VBoxContainer/DayCounter").text = dayCounterBaseText % newDay

func _on_DataManager_OnTotalBugKillsChanged(amount):
	if !infoBaseText:
		infoBaseText = get_node("VBoxContainer/InfoText").text
	get_node("VBoxContainer/InfoText").text = infoBaseText % amount


func _on_PausePlayButton_toggled(button_pressed):
	if button_pressed:
		GameManager.AttemptPause()
	else:
		GameManager.AttemptPlay()

func _on_NextWaveButton_pressed():
	GameManager.Shop.visible = false
	$"VBoxContainer/Control/ButtonHolder/CashInButton".pressed = false
	GameManager.ResourceManager.ClearCosts()
	GameManager.AttemptStartWave()

func OnGameStateChanged(var _gameState):
	match _gameState:
		GameManager.GameState.PAUSED:
			$VBoxContainer/Control/ButtonHolder/PausePlayButton.disabled = false
			$VBoxContainer/Control/ButtonHolder/NextWaveButton.disabled = true
			$VBoxContainer/Control/ButtonHolder/CashInButton.disabled = true
		GameManager.GameState.BETWEENWAVES:
			$VBoxContainer/Control/ButtonHolder/PausePlayButton.disabled = true
			$VBoxContainer/Control/ButtonHolder/NextWaveButton.disabled = false
			$VBoxContainer/Control/ButtonHolder/CashInButton.disabled = false
		GameManager.GameState.PLAYING:
			$VBoxContainer/Control/ButtonHolder/PausePlayButton.disabled = false
			$VBoxContainer/Control/ButtonHolder/NextWaveButton.disabled = true
			$VBoxContainer/Control/ButtonHolder/CashInButton.disabled = true
		GameManager.GameState.TUTORIALPAUSED:
			$VBoxContainer/Control/ButtonHolder/NextWaveButton.disabled = true
			$VBoxContainer/Control/ButtonHolder/PausePlayButton.disabled = true
			$VBoxContainer/Control/ButtonHolder/CashInButton.disabled = true


func GetCashinCosts():
	var currentPeony = GameManager.ResourceManager.get_node("Peony");
	var goldGain = Currency.new()
	goldGain.name = "Gold"
	goldGain.amount = floor(currentPeony.amount * GameManager.ResourceManager.peonyToGoldRate)
	var peonyLose = Currency.new()
	peonyLose.name = "Peony"
	peonyLose.amount = -currentPeony.amount
	var costs = [goldGain, peonyLose]
	return costs
	
func _on_CashInButton_pressed():
	if GameManager.gameState == GameManager.GameState.BETWEENWAVES:
		GameManager.Shop.visible = true;
		"""for cost in GetCashinCosts():
			cost.amount= -cost.amount
			if !GameManager.ResourceManager.Spend(cost):
				break"""


func _on_ShopButton_toggled(button_pressed):
	if GameManager.gameState == GameManager.GameState.BETWEENWAVES:
		GameManager.Shop.visible = button_pressed;
		if !button_pressed:
			GameManager.ResourceManager.ClearCosts()

func _input(event):
	if event.is_action_pressed("skip"):
		get_tree().set_input_as_handled()
		$ButtonAudio.Play()
		
		if GameManager.gameState == GameManager.GameState.BETWEENWAVES:
			_on_NextWaveButton_pressed()
		elif GameManager.gameState == GameManager.GameState.PAUSED:
			_on_PausePlayButton_toggled(false)
			$VBoxContainer/Control/ButtonHolder/PausePlayButton.pressed = false
		elif GameManager.gameState == GameManager.GameState.PLAYING:
			_on_PausePlayButton_toggled(true)
			$VBoxContainer/Control/ButtonHolder/PausePlayButton.pressed = true
