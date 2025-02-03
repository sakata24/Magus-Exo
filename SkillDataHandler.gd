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

var skill_dict = {}

# ready function runs code to grab the data
func _ready():
	skill_dict = PlayerSkills.ALL_SKILLS["skills"]

# returns a dictionary of the skill requested
func _get_ability(skill: String):
	if skill_dict.has(skill):
		return skill_dict[skill]
	else:
		return null

func get_skills():
	return skill_dict

# performs action of ability on spawn
func perform_spawn(ability, pos, caster):
	match ability.element:
		"sunder":
			ability.dmg = floor(ability.dmg * caster.current_run_data.sunder_dmg_boost)
		"entropy":
			ability.speed *= caster.current_run_data.entropy_speed_boost
			if randf_range(0, 1) < caster.current_run_data.entropy_crit_chance:
				ability.dmg = floor(ability.dmg * 1.75)
		"construct":
			ability.scale *= caster.current_run_data.construct_size_boost
		"growth":
			ability.lifetime *= caster.current_run_data.growth_lifetime_boost
			ability.get_node("LifetimeTimer").wait_time *= caster.current_run_data.growth_lifetime_boost
		"flow":
			ability.scale *= caster.current_run_data.flow_size_boost
		"wither":
			ability.lifetime *= caster.current_run_data.wither_lifetime_boost
			ability.get_node("LifetimeTimer").wait_time *= caster.current_run_data.wither_lifetime_boost
			ability.scale *= caster.current_run_data.construct_size_boost

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
	
