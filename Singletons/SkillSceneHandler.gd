# This scene is responsible for handling scene instantiation for spells and reactions to return to the requestor

extends Node

# preloaded reactions
var shatterScene = preload("res://Abilities/Reactions/Shatter.tscn")
var singularityScene = preload("res://Abilities/Reactions/Singularity.tscn")
var extinctionScene = preload("res://Abilities/Reactions/Extinction.tscn")
var blastScene = preload("res://Abilities/Reactions/Blast.tscn")
var dischargeScene = preload("res://Abilities/Reactions/Discharge.tscn")
var sicknessScene = preload("res://Abilities/Reactions/Sickness.tscn")
var overgrowthScene = preload("res://Abilities/Reactions/Overgrowth.tscn")
var breakScene = preload("res://Abilities/Reactions/Break.tscn")
var extendScene = preload("res://Abilities/Reactions/Extend.tscn")
var lifeScene = preload("res://Abilities/Reactions/Life.tscn")
var pursuitScene = preload("res://Abilities/Reactions/Pursuit.tscn")
var swarmScene = preload("res://Abilities/Reactions/Swarm.tscn")
var justiceScene = preload("res://Abilities/Reactions/Justice.tscn")
var erodeScene = preload("res://Abilities/Reactions/Erode.tscn")

# preloaded spells
var crackScene = preload("res://Abilities/Crack.tscn")
var stormScene = preload("res://Abilities/Storm.tscn")
var vineScene = preload("res://Abilities/Vine.tscn")
var fissureScene = preload("res://Abilities/Fissure.tscn")
var fountainScene = preload("res://Abilities/Fountain.tscn")
var suspendScene = preload("res://Abilities/Suspend.tscn")
var boltScene = preload("res://Abilities/Bolt.tscn")
var chargeScene = preload("res://Abilities/Charge.tscn")
var rockScene = preload("res://Abilities/Rock.tscn")
var cellScene = preload("res://Abilities/Cell.tscn")
var displaceScene = preload("res://Abilities/Displace.tscn")
var decayScene = preload("res://Abilities/Decay.tscn")

# returns an instantiated scene by the given name
func get_scene_by_name(scene_name: String) -> Node2D:
	match scene_name:
		# reactions
		"shatter": return shatterScene.instantiate()
		"singularity": return singularityScene.instantiate()
		"extinction": return extinctionScene.instantiate()
		"blast": return blastScene.instantiate()
		"discharge": return dischargeScene.instantiate()
		"sickness": return sicknessScene.instantiate()
		"overgrowth": return overgrowthScene.instantiate()
		"break": return breakScene.instantiate()
		"extend": return extendScene.instantiate()
		"life": return lifeScene.instantiate()
		"pursuit": return pursuitScene.instantiate()
		"swarm": return swarmScene.instantiate()
		"justice": return justiceScene.instantiate()
		"erode": return erodeScene.instantiate()
		# abilities
		"bolt": return boltScene.instantiate()
		"charge": return chargeScene.instantiate()
		"rock": return rockScene.instantiate()
		"cell": return cellScene.instantiate()
		"displace": return displaceScene.instantiate()
		"decay": return decayScene.instantiate()
		"crack": return crackScene.instantiate()
		"storm": return stormScene.instantiate()
		"fissure": return fissureScene.instantiate()
		"vine": return vineScene.instantiate()
		"fountain": return fountainScene.instantiate()
		"suspend": return suspendScene.instantiate()
		_:
			print("bad spell/reaction load or no reaction implemented for \"" + scene_name + "\"!")
			return null
