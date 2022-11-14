extends KinematicBody2D

var abilityID = 0
var speed = 300
var velocity = Vector2.ZERO
var dmg = 10
var timeout = 0.5
var lifetime = 0.5
var cooldown = 0.1

# constructs the bullet
func init(skillArr):
	# set variables
	abilityID = skillArr[0]
	speed = skillArr[1] * speed
	scale *= skillArr[2]
	dmg *= skillArr[3]
	timeout *= skillArr[4]
	lifetime *= skillArr[5]
	$LifetimeTimer.wait_time = lifetime
	# start timer
	$TimeoutTimer.wait_time = timeout
	$TimeoutTimer.start()
	# perform operation on spawn
	UniversalSkills.perform_spawn(self)

# handles movement of bullet
func _physics_process(delta):
	var collision = move_and_collide(velocity.normalized() * delta * speed)
	if collision and collision.collider.name != "Player":
		if collision.collider.name == "BulletBody" or collision.collider.name == "SpellBody":
			print("reaction")
		if collision.collider.is_in_group("monsters"):
			collision.collider._hit(dmg)
		UniversalSkills.perform_despawn(self)

# if end of timeout, perform action (usually start lifetime timer)
func _on_TimeoutTimer_timeout():
	$LifetimeTimer.start()
	UniversalSkills.perform_timeout(self)

func _on_LifetimeTimer_timeout():
	UniversalSkills.perform_despawn(self)

func _delete():
	queue_free()
