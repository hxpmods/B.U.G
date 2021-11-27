extends Node

var currentWave = 0

func _ready():
	GameManager.SetWaveManager(self)

func GetNextUncompletedWave():
	var wave = get_child(currentWave)
	if wave != null:
		return wave
		
func StartWave(waveId):
		
	var wave = get_child(waveId)
	currentWave = waveId
	if wave != null:
		wave.StartWave()
		PeonyToGold()
		GameManager.DataManager.Day = currentWave +1

func StartNextWave():
	var wave = GetNextUncompletedWave()
	if wave != null:
		wave.StartWave()
		PeonyToGold()
		GameManager.DataManager.Day = currentWave+1
		

func WaveFinished( wave : Node):
	GameManager.FinishWave()
	GameManager.AudioManager.PlayWaveFinished()
	currentWave +=1

func PeonyToGold():
	var peony = GameManager.ResourceManager.get_node("Peony")
	
	var amountToConvert = floor(peony.amount * 0.25)
	var cost = Currency.new()
	cost.name = "Peony"
	cost.amount = amountToConvert
	
	GameManager.ResourceManager.Spend(cost)
	GameManager.ResourceManager.AddResource("Gold", floor(amountToConvert*GameManager.ResourceManager.peonyToGoldRate))
