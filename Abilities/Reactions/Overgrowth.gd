extends Reaction

func init(reaction_components: Dictionary):
	if reaction_components["source"].element == "construct":
		set_construct_to_growth(reaction_components["source"])
	else:
		set_construct_to_growth(reaction_components["reactant"])

# sets the construct spell that generated this reaction to growth.
# also reset the reaction or the spell doesnt make sense to set to growth
func set_construct_to_growth(ability: Node2D):
	ability.element = "growth"
	ability.can_react = true
	ability.modulate = Color("#70ad47")
