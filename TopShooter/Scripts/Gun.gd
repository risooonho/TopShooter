extends Node2D

var GlobalUI
var SoundPlayer

var isReloading = false
var reloadInterval = 0.2
var timePast = 0

export var totalAmmo = 128
export var ammoPerPackage = 32

export var TimeBetwenShoots = 0.2
var BulletScene = preload("res://Prefabs/Bullet.tscn")
var LastShot = 0
var BulletsNode
var CurrentBullets = 0


func _ready():
	BulletsNode = get_node("Bullets")
	GlobalUI = get_node("/root/World/GlobalUI")
	GlobalUI.totalAmmo = totalAmmo
	GlobalUI.currentAmmo = ammoPerPackage
	CurrentBullets = ammoPerPackage
	SoundPlayer = get_node("SoundPlayer")
	
	
	set_process(true)

func _process(delta):
	Handle_Shoot_Event(delta)
	
######################################################################################
# Handlers down here
	
# Shooting	
func Handle_Shoot_Event(delta):
	if(isReloading):
		timePast -= delta
		if timePast <= 0:
			if totalAmmo > 0:
				SoundPlayer.play("error3")
				GlobalUI.totalAmmo -= 1
				GlobalUI.currentAmmo += 1
				CurrentBullets += 1
				totalAmmo -= 1
				timePast = reloadInterval
			else:
				isReloading = false
			
		if CurrentBullets == ammoPerPackage:
			isReloading = false
	else:
		if Input.is_action_pressed("Reload") and CurrentBullets < ammoPerPackage:
			if totalAmmo <= 0:
				SoundPlayer.play("hurt3")
			else:
				isReloading = true
			
		else:
	
			if(LastShot > 0):
				LastShot -= delta
			if Input.is_action_pressed("Shoot") and LastShot <= 0:
				Shoot()
	
func Shoot():
	if(CurrentBullets > 0):
		CurrentBullets -= 1
		GlobalUI.currentAmmo = CurrentBullets
		var bullet = BulletScene.instance()
		
		add_child(bullet)
		bullet.set_global_pos(BulletsNode.get_global_pos())
		bullet.set_rot(get_rot())
		bullet.force = Vector2(0,50).rotated(get_rot())
		LastShot = TimeBetwenShoots
		SoundPlayer.play("hit1")
	else:
		LastShot = TimeBetwenShoots
		SoundPlayer.play("hurt3")
