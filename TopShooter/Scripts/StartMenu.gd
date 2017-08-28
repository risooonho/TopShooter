extends Control

var MultiplayerNode
var IPLabel

func _ready():
	MultiplayerNode = get_node("Multiplayer")
	IPLabel = get_node("HostJoin/ip")

func _on_Host_pressed():
	MultiplayerNode.startServer()


func _on_Join_pressed():
	MultiplayerNode.startClient(IPLabel.get_text())
