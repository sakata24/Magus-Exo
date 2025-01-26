# This scene is responsible for handling scene instantiation for spells and reactions to return to the requestor

extends Node

# preloaded reactions
var shatterScene = preload("res://Abilities/Reactions/Shatter.tscn")
var singularityScene = preload("res://Abilities/Reactions/Singularity.tscn")
var extinctionScene = preload("res://Abilities/Reactions/Extinction.tscn")
var blastScene = preload("res://Abilities/Reactions/Blast.tscn")
var dischargeScene = preload("res://Abilities/Reactions/Discharge.tscn")
var sicknessScene = preload("res://Abilities/Reactions/Sickness.tscn")

# preloaded abilities
var crackScene = preload("res://Abilities/Crack.tscn")
var stormScene = preload("res://Abilities/Storm.tscn")

# returns an instantiated scene by the given name
func get_scene_by_name(name: String) -> Node2D:
	match name:
		# reactions
		"shatter": return shatterScene.instantiate()
		"singularity": return singularityScene.instantiate()
		"extinction": return extinctionScene.instantiate()
		"blast": return blastScene.instantiate()
		"discharge": return dischargeScene.instantiate()
		"sicknessScene": return sicknessScene.instantiate()
		# abilities
		"crack": return crackScene.instantiate()
		"storm": return stormScene.instantiate()
	return null
