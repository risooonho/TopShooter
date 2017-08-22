extends KinematicBody2D

export var Speed = 100
var BulletScene = preload("res://Prefabs/Bullet.tscn")
var TimeBetwenShoots = 0.2
var LastShot = 0

func _ready():
	set_process(true)
	set_fixed_process(true)

func _process(delta):
	if(LastShot > 0):
		LastShot -= delta
	if Input.is_action_pressed("ui_accept") and LastShot <= 0:
		var bullet = BulletScene.instance()
		
		get_parent().add_child(bullet)
		bullet.set_global_pos(get_node("Bullets").get_global_pos())
		bullet.set_rot(get_rot())
		bullet.force = Vector2(0,50).rotated(get_rot())
		LastShot = TimeBetwenShoots
	
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