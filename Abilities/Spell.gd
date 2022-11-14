extends Node

var abilityID = 0
var speed = 300
var velocity = Vector2.ZERO
var dmg = 10
var timeout = 0.5
var lifetime = 0.5
var cooldown = 0.1

const CAST_RANGE = 500

# constructs the bullet
func init(skillArr, pos):
	# set variables
	abilityID = skillArr[0]
	speed = skillArr[1] * speed
	self.scale *= skillArr[2]
	dmg *= skillArr[3]
	timeout *= skillArr[4]
	lifetime *= skillArr[5]
	self.position = pos
	$LifetimeTimer.wait_time = lifetime
	# start timer
	$TimeoutTimer.wait_time = timeout
	$TimeoutTimer.start()
	# perform operation on spawn
	UniversalSkills.perform_spawn(self)

func _ready():
	pass

func _on_SpellBody_body_entered(body):
	if body.name != "Player":
		if body.name == "BulletBody" or body.name == "SpellBody":
			print("reaction")
		if body.is_in_group("monsters"):
			body._hit(dmg)
		UniversalSkills.perform_despawn(self)

func _on_TimeoutTimer_timeout():
	$LifetimeTimer.start()
	UniversalSkills.perform_timeout(self)

func _on_LifetimeTimer_timeout():
	UniversalSkills.perform_despawn(self)
