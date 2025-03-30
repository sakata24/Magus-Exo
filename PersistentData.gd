# Holds persistent data to be updated during game play. Contains a save func.

extends Node

# player's unlocked skills
var unlocked_skills = ["bolt", "charge", "rock", "fountain"]
var equipped_skills = ["bolt", "charge", "rock", "fountain"]

# player's XP counts
var sunder_xp = 0
var entropy_xp = 0
var construct_xp = 50
var growth_xp = 0
var flow_xp = 0
var wither_xp = 0

# on load AFTER CUSTOM RESOURCE LOADER get data
func _ready():
	sunder_xp = get_node("/root/CustomResourceLoader").sunder_xp
	entropy_xp = get_node("/root/CustomResourceLoader").entropy_xp
	construct_xp = get_node("/root/CustomResourceLoader").construct_xp
	growth_xp = get_node("/root/CustomResourceLoader").growth_xp
	flow_xp = get_node("/root/CustomResourceLoader").flow_xp
	wither_xp = get_node("/root/CustomResourceLoader").wither_xp
	
	var eq_skills = get_node("/root/CustomResourceLoader").equipped_skills
	if eq_skills.size() != 0:
		equipped_skills.clear()
		for e in eq_skills:
			equipped_skills.append(e.get("name"))
	var unlk_skills = get_node("/root/CustomResourceLoader").unlocked_skills
	if unlk_skills.size()!= 0:
		unlocked_skills.clear()
		for u in get_node("/root/CustomResourceLoader").unlocked_skills:
			unlocked_skills.append(u.get("name"))
	add_to_group("Persist")

# return a dictionary of all xp counts
func get_xp_counts() -> Dictionary:
	return {"sunder_xp": sunder_xp, "entropy_xp": entropy_xp, "construct_xp": construct_xp, "growth_xp": growth_xp, "flow_xp": flow_xp, "wither_xp": wither_xp}

# return unlocked skills
func get_unlocked_skills():
	return unlocked_skills

# return equipped skills
func get_equipped_skills():
	return equipped_skills

# increase the xp gained by value given
func increase_xp(value: int, element: String):
	print("increasing xp")
	match element:
		"sunder": sunder_xp += value
		"entropy": entropy_xp += value
		"construct": construct_xp += value
		"growth": growth_xp += value
		"flow": flow_xp += value
		"wither": wither_xp += value

# save function
func save():
	# Convert unlocked skills to JSON format
	var save_skills = []
	for skill in unlocked_skills:
		save_skills.append({"name": skill})
	# Convert equipped skills to JSON format
	var save_equipped_skills = []
	for skill in equipped_skills:
		save_equipped_skills.append({"name": skill})
	# Create the 
	var save_dict = {
		"sunder_xp": sunder_xp,
		"entropy_xp": entropy_xp,
		"construct_xp": construct_xp,
		"growth_xp": growth_xp,
		"flow_xp": flow_xp,
		"wither_xp": wither_xp,
		"unlocked_skills": save_skills,
		"equipped_skills": save_equipped_skills
	}
	return save_dict
