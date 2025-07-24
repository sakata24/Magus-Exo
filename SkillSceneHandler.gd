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
func get_scene_by_name(scene_name: String) -> PackedScene:
	match scene_name:
		# reactions
		"shatter": return shatterScene
		"singularity": return singularityScene
		"extinction": return extinctionScene
		"blast": return blastScene
		"discharge": return dischargeScene
		"sickness": return sicknessScene
		"overgrowth": return overgrowthScene
		"break": return breakScene
		"extend": return extendScene
		"life": return lifeScene
		"pursuit": return pursuitScene
		"swarm": return swarmScene
		"justice": return justiceScene
		"erode": return erodeScene
		# abilities
		"bolt": return boltScene
		"charge": return chargeScene
		"rock": return rockScene
		"cell": return cellScene
		"displace": return displaceScene
		"decay": return decayScene
		"crack": return crackScene
		"storm": return stormScene
		"fissure": return fissureScene
		"vine": return vineScene
		"fountain": return fountainScene
		"suspend": return suspendScene
		_:
			print("bad spell/reaction load or no reaction implemented for \"" + scene_name + "\"!")
			return null
