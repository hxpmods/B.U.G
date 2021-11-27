extends Node


var DataManager;
var WaveManager;
var AntManager;
var ResourceManager;
var EntityManager;
var SelectionManager;
var SkillsManager
var BulletManager;
var PickupManager;
var AudioManager;
var Buildables;
var Spawnables;
var Shop;
var UpgradesMenu;
var PopUpBox;
var BlueprintPlacer;

var MainMenu;

var gameState = GameState.BETWEENWAVES

enum GameState {
	PLAYING, PAUSED, BETWEENWAVES, TUTORIALPAUSED
}

signal OnGameStateChanged(gameState)


func OpenMainMenu():
	PopUpBox.disconnect("OnConfirmationPressed", self, "OpenMainMenu")
	get_tree().get_root().add_child(MainMenu.get_parent())
	var game = get_tree().get_root().get_node("Game")
	get_tree().get_root().remove_child(game)
	game.queue_free()

func StartGame():
	WaveManager.StartNextWave()

func StartDevMode(initialWave):
	for currency in ResourceManager.get_children():
		ResourceManager.AddResource(currency.name, 1000)
	
	for buildable in Buildables.get_children():
		buildable.SetUnlocked(true)
	
	WaveManager.StartWave(initialWave)
	SetGameState(GameState.PAUSED)
		
func LoseGame():
	#SetGameState(GameState.GAMEOVER)
	self.PopUpBox.Open(Vector2(450,250),Vector2(900,450),"You Lost",self.DataManager.GetGameOverStats())
	PopUpBox.connect("OnConfirmationPressed", self, "OpenMainMenu")

func WinGame():
	#SetGameState(GameState.GAMEOVER)
	self.PopUpBox.Open(Vector2(450,250),Vector2(900,450),"You Won",self.DataManager.GetGameOverStats())
	PopUpBox.connect("OnConfirmationPressed", self, "OpenMainMenu")
	
func AttemptPause():
	if gameState == GameState.PLAYING:
		SetGameState(GameState.PAUSED)
		
func AttemptPlay():
	if gameState == GameState.PAUSED:
		SetGameState(GameState.PLAYING)

func FinishWave():
	SetGameState(GameState.BETWEENWAVES)

func AttemptStartWave():
	if WaveManager.GetNextUncompletedWave() != null:
		if gameState == GameState.BETWEENWAVES:
			SetGameState(GameState.PLAYING)
			WaveManager.StartNextWave()
		
func SetGameState(_gameState):
	if is_inside_tree():
		match _gameState:
			GameState.PAUSED:
				get_tree().paused = true
			GameState.BETWEENWAVES:
				get_tree().paused = true
			GameState.PLAYING:
				get_tree().paused = false
			GameState.TUTORIALPAUSED:
				get_tree().paused = true
		self.gameState = _gameState
		emit_signal("OnGameStateChanged", self.gameState)

func SetPickupManager( var pickupManager):
	self.PickupManager = pickupManager

func SetAntManager( var antManager):
	self.AntManager = antManager

func SetSkillsManager(var skillsManager):
	self.SkillsManager = skillsManager
	
func SetAudioManager( var audioManager):
	self.AudioManager = audioManager

func SetBulletManager( var bulletManager):
	self.BulletManager = bulletManager
	
func SetDataManager( var dataManager):
	self.DataManager = dataManager

func SetEntityManager( var entityManager):
	self.EntityManager = entityManager

func SetResourceManager( var resManager):
	self.ResourceManager = resManager

func SetWaveManager( var waveManager):
	self.WaveManager = waveManager

func SetBuildables( var buildables):
	self.Buildables = buildables

func SetSpawnables( var spawnables):
	self.Spawnables = spawnables

func SetUpgradesMenu(var menu):
	self.UpgradesMenu = menu

func SetBlueprintPlacer( var blueprintPlacer):
	self.BlueprintPlacer = blueprintPlacer;

func SetSelectionManager(var selectionManager):
	self.SelectionManager = selectionManager

func SetPopUpBox(var popUpBox):
	self.PopUpBox = popUpBox

func SetShop( var shop):
	self.Shop = shop
