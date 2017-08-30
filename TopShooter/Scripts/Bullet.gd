# bullet.gd -> RigidBody2D
extends RigidBody2D

var owner
var force = Vector2(0,0) # The force of movement
var source # The shooter of the bullet
var die_on_timeout = true # Should the bullet be removed when there is no time left?
export var take_player_speed = 0.5 # Should the bullet inherit the player's speed
export var speed = 60.0 # The speed of the bullet (around 700 makes for a normal spped)
export var time_left = 3.0 # The time left for the bullet to live
export var damage = 1.0 # The damage that the bullet will cause
var animationPlayer # The animation player!
export var dangerous = true # Is it still dangerous to touch?

func _ready():
	set_fixed_process(true) # We use _fixed_process to move and die

func _fixed_process(delta):
	time_left -= delta # Decrease the time left for the bullet to live
	if((time_left <= 0.0) and (die_on_timeout)):
		dangerous = false # No more danger!
		queue_free()
	
	if(dangerous):
		#TODO: make some teams here
		set_linear_velocity(get_linear_velocity() + force) # Set its velocity
		force = force.linear_interpolate(Vector2(0, 0), delta*4)
		for body in get_colliding_bodies(): # For each boddy we collide with
			if(body.has_method("damage")):
				body.damage(source,damage) # Damage it if possible
			dangerous = false # No more danger!
			queue_free()