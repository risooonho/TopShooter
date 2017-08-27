extends KinematicBody2D

######################################################################################
# Globals and vars
var GlobalUI
var SoundPlayer

# Walking
export var WalkSpeed = 100

######################################################################################
# Main functions

var client1 = null
var client2 = null
var peer1 = null
var peer2 = null
var server = null

func _ready():
	var address = GDNetAddress.new()
	address.set_host("localhost")
	address.set_port(3000)

	server = GDNetHost.new()
	server.bind(address)

	client1 = GDNetHost.new()
	client1.bind()
	peer1 = client1.connect(address)

	client2 = GDNetHost.new()
	client2.bind()
	peer2 = client2.connect(address)
	set_process(true)
	set_fixed_process(true)
	

func _process(delta):
	if (client1.is_event_available()):
		var event = client1.get_event()
		
		if (event.get_event_type() == GDNetEvent.CONNECT):
			print("Client1 connected")
			peer1.send_var("Hello from client 1", 0)
			
		if (event.get_event_type() == GDNetEvent.RECEIVE):
			print(event.get_var())

	if (client2.is_event_available()):
		var event = client2.get_event()
		
		if (event.get_event_type() == GDNetEvent.CONNECT):
			print("Client2 connected")
			peer2.send_var("Hello from client 2", 0)
			
		if (event.get_event_type() == GDNetEvent.RECEIVE):
			print(event.get_var())

	if (server.is_event_available()):
		var event = server.get_event()
		
		if (event.get_event_type() == GDNetEvent.CONNECT):
			var peer = server.get_peer(event.get_peer_id())
			var address = peer.get_address();
			print("Peer connected from ", address.get_host(), ":", address.get_port())
			peer.send_var(str("Hello from server to peer ", event.get_peer_id()), 0)
			
		elif (event.get_event_type() == GDNetEvent.RECEIVE):
			print(event.get_var())
			server.broadcast_var("Server broadcast", 0)
	
	pass
	
func _fixed_process(delta):
	Handle_Walk_Rotation_Event(delta)
	
# Walking
func Handle_Walk_Rotation_Event(delta):
	var motion = Vector2()
	var PlayerPos = get_pos()
		
	if Input.is_action_pressed("ui_up"):
		motion += Vector2(0,-1)
		
	if Input.is_action_pressed("ui_down"):
		motion += Vector2(0,1)
		
	if Input.is_action_pressed("ui_left"):
		motion += Vector2(-1,0)
		
	if Input.is_action_pressed("ui_right"):
		motion += Vector2(1,0)
		
	motion = motion.normalized()*WalkSpeed*delta
	move(motion)
	
	var mousePos = get_global_mouse_pos()
	look_at(mousePos)