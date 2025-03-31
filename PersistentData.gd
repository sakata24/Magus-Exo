# Holds persistent data to be updated during game play. Contains a save func. Accessible from anywhere for easy access.

extends Node

# player's unlocked skills
var unlocked_skills = ["bolt", "charge", "rock", "fountain"]
var equipped_skills = ["bolt", "charge", "rock", "fountain"]

# player's XP counts
var sunder_xp = 0
var entropy_xp = 0
var construct_xp = 0
var growth_xp = 0
var flow_xp = 0
var wither_xp = 0

func _ready():
	add_to_group("Persist")
	# always try to have a save file on load
	fetch_save_data()

# return persistent data as a dictionary
func get_all_data() -> Dictionary:
	return {
		"sunder_xp": sunder_xp,
		"entropy_xp": entropy_xp,
		"construct_xp": construct_xp,
		"growth_xp": growth_xp,
		"flow_xp": flow_xp,
		"wither_xp": wither_xp,
		"unlocked_skills": unlocked_skills,
		"equipped_skills": equipped_skills
	}

# this function's purpose is to grab and assign data to this file's instance variables
func fetch_save_data():
	# load a save
	var saved_data: Dictionary = CustomResourceLoader.load_game()
	
	# if no save file, create one with default variables. This should ensure that the saved data always matches properly
	if saved_data.size() <= 0:
		print("No save data detected.")
	
	# verify the data in the json, then patch it
	verify_json_data(saved_data)
	
	# load the XP values
	sunder_xp = saved_data["sunder_xp"]
	entropy_xp = saved_data["entropy_xp"]
	construct_xp = saved_data["construct_xp"]
	growth_xp = saved_data["growth_xp"]
	flow_xp = saved_data["flow_xp"]
	wither_xp = saved_data["wither_xp"]
	
	# load all the unlocked spells
	unlocked_skills = saved_data["unlocked_skills"]
	if unlocked_skills.size() < 4:
		print("Problem loading unlocked skills. Setting to default.")
		unlocked_skills = ["bolt", "charge", "rock", "fountain"]
	
	# load the last equipped spells
	equipped_skills = saved_data["equipped_skills"]
	if unlocked_skills.size() < 4:
		print("Problem loading equipped skills. Setting to default.")
		equipped_skills = ["bolt", "charge", "rock", "fountain"]

	print("Finished loading!\n")
	print(get_all_data())

# return a dictionary of all xp counts
func get_xp_counts() -> Dictionary:
	return {"sunder_xp": sunder_xp, "entropy_xp": entropy_xp, "construct_xp": construct_xp, "growth_xp": growth_xp, "flow_xp": flow_xp, "wither_xp": wither_xp}

# return unlocked skills
func get_unlocked_skills() -> Array:
	return unlocked_skills

# return equipped skills
func get_equipped_skills() -> Array:
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
		save_skills.append(skill)
	# Convert equipped skills to JSON format
	var save_equipped_skills = []
	for skill in equipped_skills:
		save_equipped_skills.append(skill)
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

# verifies that all necessary fields are present in the loaded save. if not, fix it
func verify_json_data(json: Dictionary):
	for field in get_script().get_script_property_list():
		if field.name not in json.keys():
			print("key not found for: " + field.name)
			json[field.name] = get(field.name)
