# Contains functions related to a Sunder ability.
# All Sunder abilities should preload this resource.

extends Resource

# Creates a new reaction.
func create_new_reaction(source: Node2D, reactant: Node2D):
	var reaction_origin = get_reaction_origin(source, reactant)
	var reaction_scene = get_reaction_scene(source.element, reactant.element)

# determine which spell the reaction originates from
func get_reaction_origin(source: Node2D, reactant: Node2D):
	if source.reaction_priority > reactant.reaction_priority:
		return source
	else: 
		return reactant

# returns a scene based on the type of reaction
func get_reaction_scene(sourceElement: String, reactantElement: String):
	pass
