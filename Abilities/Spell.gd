extends Area2D

var abilityID = 0
var speed = 300
var velocity = Vector2.ZERO
var dmg = 10
var timeout = 1
var lifetime = 1
var cooldown = 0.1
var canReact = true
var element

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
	element = skillDict["element"]
	self.modulate.a = 0.5
	print(element)
	if element == "sunder":
		$Texture.color = Color("#c00000")
	elif element == "entropy":
		$Texture.color = Color("#ffd966")
	elif element == "construct":
		$Texture.color = Color("#833c0c")
	elif element == "growth":
		$Texture.color = Color("#70ad47")
	elif element == "flow":
		$Texture.color = Color("#9bc2e6")
	elif element == "wither":
		$Texture.color = Color("#7030a0")
	add_to_group("skills")
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
		if body.is_in_group("skills") and canReact:
			print("reaction with " + body.element + " + " + self.element)
			self.canReact = false
			body.canReact = false
			UniversalSkills.perform_reaction(body, self)
		if body.is_in_group("monsters"):
			body._hit(dmg, $Texture.color)

func _on_area_entered(area):
	if area.name == "SpellBody" and canReact:
		self.canReact = false
		area.canReact = false
		UniversalSkills.perform_reaction(area, self)

func _on_TimeoutTimer_timeout():
	$LifetimeTimer.start()
	UniversalSkills.perform_timeout(self)

func _on_LifetimeTimer_timeout():
	UniversalSkills.perform_despawn(self)
