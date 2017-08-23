extends CanvasLayer

var currentAmmo = 0 setget set_currentAmmo
var totalAmmo = 0 setget set_totalAmmo

func set_currentAmmo(value):
	currentAmmo = value
	get_node("GunBullets/Label").set_text(str(currentAmmo) + "/" + str(totalAmmo))

func set_totalAmmo(value):
	totalAmmo = value
	get_node("GunBullets/Label").set_text(str(currentAmmo) + "/" + str(totalAmmo))

func _ready():
	pass
