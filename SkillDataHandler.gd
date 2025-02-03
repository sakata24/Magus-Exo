# This script is solely responsible for holding and returning data of specific spellsSkillDataHandler

extends Node

var shatterScene = preload("res://Abilities/Reactions/Shatter.tscn")
var singularityScene = preload("res://Abilities/Reactions/Singularity.tscn")
var extinctionScene = preload("res://Abilities/Reactions/Extinction.tscn")
var blastScene = preload("res://Abilities/Reactions/Blast.tscn")
var dischargeScene = preload("res://Abilities/Reactions/Discharge.tscn")
var sicknessScene = preload("res://Abilities/Reactions/Sickness.tscn")

var crackScene = preload("res://Abilities/Crack.tscn")
var stormScene = preload("res://Abilities/Storm.tscn")

var reactionText = preload("res://HUDs/ReactionText.tscn")

var skillDict = {}

# ready function runs code to grab the data
func _ready():
	skillDict = PlayerSkills.ALL_SKILLS["skills"]

# returns a dictionary of the skill requested
func _get_ability(skill):
	if skillDict.has(skill):
		return skillDict[skill]
	else:
		return null

# make a timer that ticks. ability is a reference, tick is how often
func start_tick_timer(ability, tick, my_lambda: Callable):
	var timer = Timer.new()
	timer.wait_time = tick
	ability.add_child(timer)
	while true:
		timer.start()
		my_lambda.call(ability)
		await timer.timeout
	timer.queue_free()

# performs action of ability on spawn
func perform_spawn(ability, pos, caster):
	match ability.element:
		"sunder":
			ability.dmg = floor(ability.dmg * caster.sunder_dmg_boost)
		"entropy":
			ability.speed *= caster.entropy_speed_boost
			if randf_range(0, 1) < caster.entropy_crit_chance:
				ability.dmg = floor(ability.dmg * 1.75)
		"construct":
			ability.scale *= caster.construct_size_boost
		"growth":
			ability.lifetime *= caster.growth_lifetime_boost
			ability.get_node("LifetimeTimer").wait_time *= caster.growth_lifetime_boost
		"flow":
			ability.scale *= caster.flow_size_boost
		"wither":
			ability.lifetime *= caster.wither_lifetime_boost
			ability.get_node("LifetimeTimer").wait_time *= caster.wither_lifetime_boost
			ability.scale *= caster.construct_size_boost

# helper method to create spells cast from char
func clamp_vector(vector, clamp_origin, clamp_length):
	var offset = (vector - clamp_origin).normalized() * 10000
	return clamp_origin + offset.limit_length(clamp_length)

# performs action of an ability on timeout
func perform_timeout(ability):
	match ability.abilityID:
		"bolt":
			pass
		"crack":
			ability.set_collision_mask_value(2, false)
		"charge":
			ability.speed = 1.4 * 300
			ability.dmg = floor(ability.dmg * 1.5)
			ability.scale = ability.scale * 1.5
		"rock":
			pass
		"cell":
			pass
		"fountain":
			pass
		"suspend":
			pass
			ability.modulate.a = 0.3
		_:
			pass

# performs action of an ability before despawn
func perform_despawn(ability, target):
	if target != null:
		match ability.abilityID:
			"decay":
				target.speed *= 0.5
				ability.queue_free()
				var timer = Timer.new()
				timer.wait_time = 0.5
				target.add_child(timer)
				timer.start()
				await timer.timeout
				target.speed *= 2
			_:
				ability.queue_free()
	else:
		ability.queue_free()

func spawn_reaction_name(name: String, originSpell, dmg_color_1: Color, dmg_color_2: Color):
	var reactionText = reactionText.instantiate()
	reactionText.set_colors(dmg_color_1, dmg_color_2)
	originSpell.get_parent().add_child(reactionText)
	reactionText.set_value_and_pos(name, originSpell.position)

func perform_reaction(collider, collided):
	#TO CHECK ENEMY SPELLS (specifically VolitileSpike)
	if collider.is_in_group("enemy_skills"):
		collider.react()
		return
	elif collided.is_in_group("enemy_skills"):
		collider.react()
		return
	print("reaction " + collider.element + " " + collided.element)
	# pause timers if reaction so it may complete
	collided.get_node("LifetimeTimer").paused = true
	collider.get_node("LifetimeTimer").paused = true
	#Sunder: #7a0002
	#Entropy: #7a0002
	#Growth: #36c72c
	#Construct: #663c33
	#Flow: #82b1ff
	#Wither: #591b82
	match collider.element + collided.element:
		"wither" + "growth":
			# EXTEND: Greatly increase lifetime of both spells
			collided.get_node("LifetimeTimer").wait_time = collided.get_node("LifetimeTimer").wait_time * 1.5
			collider.get_node("LifetimeTimer").wait_time = collider.get_node("LifetimeTimer").wait_time * 1.5
			collided.get_node("TimeoutTimer").wait_time = collided.get_node("TimeoutTimer").wait_time * 1.5
			collider.get_node("TimeoutTimer").wait_time = collider.get_node("TimeoutTimer").wait_time * 1.5
			collided.get_node("TimeoutTimer").start()
			collider.get_node("TimeoutTimer").start()
			spawn_reaction_name("extend!", collided, Color("#36c72c"), Color("#591b82"))
		"growth" + "wither":
			# EXTEND: Greatly increase lifetime of both spells
			collided.get_node("LifetimeTimer").wait_time = collided.get_node("LifetimeTimer").wait_time * 1.5
			collider.get_node("LifetimeTimer").wait_time = collider.get_node("LifetimeTimer").wait_time * 1.5
			collided.get_node("TimeoutTimer").wait_time = collided.get_node("TimeoutTimer").wait_time * 1.5
			collider.get_node("TimeoutTimer").wait_time = collider.get_node("TimeoutTimer").wait_time * 1.5
			collided.get_node("TimeoutTimer").start()
			collider.get_node("TimeoutTimer").start()
			spawn_reaction_name("extend!", collided, Color("#36c72c"), Color("#591b82"))
		_:
			collided.get_node("TimeoutTimer").paused = false
			collided.get_node("LifetimeTimer").paused = false
			collider.get_node("TimeoutTimer").paused = false
			collider.get_node("LifetimeTimer").paused = false
			print("no reaction implemented!")
			
func get_skills():
	return skillDict
