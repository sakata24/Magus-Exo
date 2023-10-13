extends CharacterBody2D

var abilityID = 0
var speed = 300
var dmg = 10
var timeout = 1.0
var lifetime = 1.0
var cooldown = 0.1
var element

# constructs the bullet
func init(skillDict):
	# set variables
	abilityID = skillDict["name"]
	speed = skillDict["speed"] * speed
	scale *= skillDict["size"]
	dmg *= skillDict["dmg"]
	timeout *= skillDict["timeout"]
	lifetime *= skillDict["lifetime"]
	element = skillDict["element"]
	$LifetimeTimer.wait_time = lifetime
	# start timer
	$TimeoutTimer.wait_time = timeout
	$TimeoutTimer.start()
	# perform operation on spawn
	UniversalSkills.perform_spawn(self)

# handles movement of bullet
func _physics_process(delta):
	var collision = move_and_collide(get_velocity().normalized() * delta * speed)
	if collision and collision.get_collider().get_name() != "Player":
		if collision.get_collider().get_name() == "BulletBody" or collision.get_collider().get_name() == "SpellBody":
			print("reaction")
		if collision.get_collider().is_in_group("monsters"):
			collision.get_collider()._hit(dmg)
		UniversalSkills.perform_despawn(self)

# if end of timeout, perform action (usually start lifetime timer)
func _on_TimeoutTimer_timeout():
	$LifetimeTimer.start()
	UniversalSkills.perform_timeout(self)

func _on_LifetimeTimer_timeout():
	UniversalSkills.perform_despawn(self)

func _delete():
	queue_free()
