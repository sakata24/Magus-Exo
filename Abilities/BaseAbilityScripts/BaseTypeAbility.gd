# Class responsible for handling reactions of a "type"
# Meant to act as an interface for <type>Ability.gd

class_name BaseTypeAbility extends Resource

# Creates a new reaction.
func create_new_reaction(spell_1: Node2D, spell_2: Node2D):
	var reaction_components = get_reaction_source_and_reactant(spell_1, spell_2)
	var reaction_scene = get_reaction_scene(spell_2.element)
	if reaction_scene:
		# set as the child
		reaction_components["source"].add_child(reaction_scene)
		# after entering tree things and if need info from both spells reacting
		reaction_scene.init(reaction_components)

# determine the source and reactant
func get_reaction_source_and_reactant(source: Node2D, reactant: Node2D) -> Dictionary:
	# higher priority means the reaction sticks to it more often
	if source.reaction_priority > reactant.reaction_priority:
		return {"source": source, "reactant": reactant}
	else: 
		return {"source": reactant, "reactant": source}

# FUNCTION TO BE OVERLOADED
func get_reaction_scene(reactant_element: String) -> Node2D:
	print("reaction not implemented!")
	return null
