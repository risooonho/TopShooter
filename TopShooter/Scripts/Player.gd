extends KinematicBody2D

export var Speed = 100

func _ready():
	set_process(true)
	set_fixed_process(true)

func _process(delta):
	pass
	
func _fixed_process(delta):
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
		
	motion = motion.normalized()*Speed*delta
	move(motion)
	
	var mousePos = get_global_mouse_pos()
	look_at(mousePos)