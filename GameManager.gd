extends Control
class_name GameManager

var player1: PlayerData
var player2: PlayerData
var activePlayer: PlayerData

func _ready():
	CardDB.getInstance()
	
func onTurnStart():
	turnStartRefresh(activePlayer)
	
func onTurnEnd():
	pass
	
func onBetweenTurns():
	activePlayer = player1 if activePlayer == player2 else player2
	onTurnStart()

func turnStartRefresh(player:PlayerData):
	player.moveLeft = 3
