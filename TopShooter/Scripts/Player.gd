extends KinematicBody2D

######################################################################################
# Globals and vars
var GlobalUI
var SoundPlayer

# Walking
export var WalkSpeed = 100

######################################################################################
# Main functions

func _ready():
	var host = NetworkedMultiplayerENet.new()
	
	set_process(true)
	set_fixed_process(true)
	

func _process(delta):
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