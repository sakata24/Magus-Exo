# This script is solely responsible for holding and returning data of specific spellsSkillDataHandler

extends Node

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
	
