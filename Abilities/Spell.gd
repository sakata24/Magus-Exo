class_name Spell extends Area2D

var abilityID = 0
var speed = 300
var velocity = Vector2.ZERO
var dmg = 10
var timeout = 1
var lifetime = 1
var cooldown = 0.1
var size = 1
var reaction_priority = 0
var element
var can_react
var spellCaster

const CAST_RANGE = 500

# constructs the bullet
func init(skillDict, castTarget, caster):
	# set variables
	abilityID = skillDict["name"]
	element = skillDict["element"]
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
	spellCaster = caster
	self.position = castTarget
	
	# perform operation on spawn
	SkillDataHandler.perform_spawn(self, castTarget, caster)

func _ready():
	pass

func _on_SpellBody_body_entered(body):
	if body.name != "Player":
		if body.is_in_group("skills"):
			set_collision_layer_value(3, false)
			set_collision_mask_value(3, false)
			SkillDataHandler.perform_reaction(body, self)
		if body.is_in_group("monsters"):
			body._hit(dmg, element, element, spellCaster)

func _on_area_entered(area):
	print("reaction not implemented yet!")

func _on_TimeoutTimer_timeout():
	$LifetimeTimer.start()
	SkillDataHandler.perform_timeout(self)

func _on_LifetimeTimer_timeout():
	SkillDataHandler.perform_despawn(self, null)
