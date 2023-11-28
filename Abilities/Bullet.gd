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
	if element == "sunder":
		$ColorRect.color = Color("#c00000")
	elif element == "entropy":
		$ColorRect.color = Color("#ffd966")
	elif element == "construct":
		$ColorRect.color = Color("#833c0c")
	elif element == "growth":
		$ColorRect.color = Color("#70ad47")
	elif element == "flow":
		$ColorRect.color = Color("#9bc2e6")
	elif element == "wither":
		$ColorRect.color = Color("#7030a0")
		
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
			print("reaction with " + collision.get_collider().element + " + " + self.element)
			UniversalSkills.perform_reaction(self, collision.get_collider())
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
