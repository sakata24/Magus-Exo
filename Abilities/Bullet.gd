class_name Bullet extends CharacterBody2D

var abilityID = 0
var speed = 300
var dmg = 10
var timeout = 1.0
var lifetime = 1.0
var cooldown = 0.1
var can_react = true
var size = 1
var reaction_priority = 0
var element
var spell_caster

# constructs the bullet
func init(skillDict, castTarget, caster):
	# set variables
	abilityID = skillDict["name"]
	speed = skillDict["speed"] * speed
	size *= skillDict["size"]
	dmg *= skillDict["dmg"]
	timeout *= skillDict["timeout"]
	lifetime *= skillDict["lifetime"]
	element = skillDict["element"]
	if element == "flow":
		$AnimatedSprite2D.set_sprite_frames(CustomResourceLoader.flowSpriteRes)
		$Texture.color = Color("#9bc2e6")
	elif element == "wither":
		$AnimatedSprite2D.set_sprite_frames(CustomResourceLoader.witherSpriteRes)
		$Texture.color = Color("#7030a0")
	add_to_group("skills")
	look_at(castTarget)
	# play the anim
	$AnimatedSprite2D.play()
	$LifetimeTimer.wait_time = lifetime
	scale *= size
	# keep a reference to the caster
	spell_caster = caster
	# perform operation on spawn
	SkillDataHandler.perform_spawn(self, castTarget, caster)

# handles movement of bullet
func _physics_process(delta):
	pass

# if end of timeout, perform action (usually start lifetime timer)
func _on_TimeoutTimer_timeout():
	$LifetimeTimer.start()
	SkillDataHandler.perform_timeout(self)

func _on_LifetimeTimer_timeout():
	SkillDataHandler.perform_despawn(self, null)

func despawn():
	queue_free()

func _delete():
	queue_free()
