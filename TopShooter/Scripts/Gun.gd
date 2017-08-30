extends Node2D

var GlobalUI
var SoundPlayer

var isReloading = false
export var reloadInterval = 0.2
var timePast = 0

export var totalAmmo = 128
export var ammoPerPackage = 32

export var TimeBetwenShoots = 0.2
var BulletScene = preload("res://Prefabs/Bullet.tscn")
var LastShot = 0
var BulletsNode
var CurrentBullets = 0

func get_random_number():
    randomize()
    return randi()%11

sync func setup_bullet(pos, rot, by_who):
	var bullet = BulletScene.instance()
	bullet.set_name("Bullet-" + str(get_random_number()))
	bullet.owner = by_who
	bullet.set_global_pos(pos)
	bullet.set_rot(rot)
	bullet.force = Vector2(0,50).rotated(rot)
	get_parent().get_parent().add_child(bullet)

func _ready():
	BulletsNode = get_node("Bullets")
	GlobalUI = get_node("/root/world/GlobalUI")
	GlobalUI.totalAmmo = totalAmmo
	GlobalUI.currentAmmo = ammoPerPackage
	CurrentBullets = ammoPerPackage
	SoundPlayer = get_node("SoundPlayer")
	
	
	set_process(true)

func _process(delta):
	if (is_network_master()):
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
		var parentRot = get_parent().get_rot()
		CurrentBullets -= 1
		GlobalUI.currentAmmo = CurrentBullets

		rpc("setup_bullet", BulletsNode.get_global_pos(), parentRot, get_tree().get_network_unique_id())


		LastShot = TimeBetwenShoots
		SoundPlayer.play("hit1")
	else:
		LastShot = TimeBetwenShoots
		SoundPlayer.play("hurt3")
