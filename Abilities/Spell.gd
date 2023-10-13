extends Node

var abilityID = 0
var speed = 300
var velocity = Vector2.ZERO
var dmg = 10
var timeout = 1
var lifetime = 1
var cooldown = 0.1

const CAST_RANGE = 500

# constructs the bullet
func init(skillDict, pos):
	# set variables
	abilityID = skillDict["name"]
	speed = skillDict["speed"] * speed
	self.scale *= skillDict["size"]
	dmg *= skillDict["dmg"]
	timeout *= skillDict["timeout"]
	lifetime *= skillDict["lifetime"]
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
		if body.name == "BulletBody":
			print("reaction")
		if body.is_in_group("monsters"):
			body._hit(dmg)

func _on_area_entered(area):
	if area.name == "SpellBody":
		print("reaction spells")

func _on_TimeoutTimer_timeout():
	$LifetimeTimer.start()
	UniversalSkills.perform_timeout(self)

func _on_LifetimeTimer_timeout():
	UniversalSkills.perform_despawn(self)
