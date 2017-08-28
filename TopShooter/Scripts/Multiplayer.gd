extends Node2D

var SERVER_PORT = 25567
var myUsername = "Player" setget set_myUsername

var map1 = preload("res://Scenes/Map1.tscn")
var player = preload("res://Prefabs/Player.tscn")

var player_info = {}

func set_myUsername(value):
	myUsername = value
	
func getMyInfo():
	return {"username": myUsername}

func _ready():
    get_tree().connect("network_peer_connected", self, "_player_connected")
    get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
    get_tree().connect("connected_to_server", self, "_connected_ok")
    get_tree().connect("connection_failed", self, "_connected_fail")
    get_tree().connect("server_disconnected", self, "_server_disconnected")

func startServer():
	var host = NetworkedMultiplayerENet.new()
	host.create_server(SERVER_PORT, 4)
	get_tree().set_network_peer(host)
	print(IP.get_local_addresses())

func startClient(ip):
	var host = NetworkedMultiplayerENet.new()
	host.create_client(ip, SERVER_PORT)
	get_tree().set_network_peer(host)

func _player_connected(id):
	print("alguem entrou")

func _player_disconnected(id):
	print("alguem saiu")
	player_info.erase(id) # Erase player from info

func _connected_ok():
	rpc("register_player", get_tree().get_network_unique_id(), getMyInfo())
	print("coneccao ok")

func _server_disconnected():
    pass # Server kicked us, show error and abort

func _connected_fail():
	print("con falhou")

remote func register_player(id, info):
	# Store the info
	player_info[id] = info
	# If I'm the server, let the new guy know about existing players
	if (get_tree().is_network_server()):
		# Send my info to new player
		rpc_id(id, "register_player", 1, getMyInfo())
		# Send the info of existing players
		for peer_id in player_info:
			rpc_id(id, "register_player", peer_id, player_info[peer_id])
	
		if(player_info.size() > 1):
			print("pre configurar")
			rpc("pre_configure_game")
	

remote func pre_configure_game():
	get_tree().set_pause(true)
	
	# Load world
	var world = load("res://Scenes/Map1.tscn").instance()
	get_node("/root").add_child(world)
	
	# Load my player
	var my_player = player.instance()
	my_player.set_name(str(get_tree().get_network_unique_id()))
	my_player.set_network_mode(NETWORK_MODE_MASTER) # Will be explained later
	get_node("/root/World").add_child(my_player)
	
	# Load other players
	for p in player_info:
	    var other_player = player.instance()
	    other_player.set_name(str(p))
	    other_player.set_network_mode(NETWORK_MODE_SLAVE) # Will be explained later
	    get_node("/root/World").add_child(other_player)
	
	# Tell server (remember, server is always ID=1) that this peer is done pre-configuring
	rpc_id(1, "done_preconfiguring", get_tree().get_network_unique_id())
	
var players_done = []
remote func done_preconfiguring(who):
	# Here is some checks you can do, as example
	assert(get_tree().is_network_server())
	assert(who in player_info) # Exists
	assert(not who in players_done) # Was not added yet
	
	players_done.append(who)

	if (players_done.size() == player_info.size()):
		print("pos configurar")
		rpc("post_configure_game")

remote func post_configure_game():
    get_tree().set_pause(false)
    # Game starts now!