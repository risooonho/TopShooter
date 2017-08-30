extends KinematicBody2D

var GlobalUI
var SoundPlayer
var ListenInputs = true

# Walking
export var WalkSpeed = 100

slave var slave_pos = Vector2()
slave var slave_motion = Vector2()
slave var slave_rotation = Vector2()

func _fixed_process(delta):
	Handle_Walk_Rotation_Event(delta)

func Handle_Walk_Rotation_Event(delta):
	var motion = Vector2()
	var rotation = Vector2()
		
	if (is_network_master()):
		if Input.is_action_pressed("ui_up"):
			motion += Vector2(0,-1)
			
		if Input.is_action_pressed("ui_down"):
			motion += Vector2(0,1)
			
		if Input.is_action_pressed("ui_left"):
			motion += Vector2(-1,0)
			
		if Input.is_action_pressed("ui_right"):
			motion += Vector2(1,0)
			
			
		rset("slave_motion", motion)
		rset("slave_pos", get_pos())
		rset("slave_rotation", get_global_mouse_pos())
		rotation = get_global_mouse_pos()
	else:
		set_pos(slave_pos)
		motion = slave_motion
		rotation = slave_rotation
			
			
			
			
	motion = motion.normalized()*WalkSpeed*delta
	var remainder = move(motion)

	if (is_colliding()):
		# Slide through walls
		move(get_collision_normal().slide(remainder))
	
	look_at(rotation)
	

	if (not is_network_master()):
		slave_pos = get_pos() # To avoid jitter

func set_player_name(name):
	get_node("label").set_text(name)

func _ready():
	slave_pos = get_pos()
	set_fixed_process(true)
