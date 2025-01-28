extends Reaction

func init(reaction_components: Dictionary):
	if reaction_components["source"].element == "construct":
		set_construct_to_growth(reaction_components["source"])
	else:
		set_construct_to_growth(reaction_components["reactant"])

# sets the construct spell that generated this reaction to growth.
# also reset the reaction or the spell doesnt make sense to set to growth
func set_construct_to_growth(construct_ability: Node2D):
	# reset collision with spells
	construct_ability.set_collision_layer_value(3, true)
	construct_ability.set_collision_mask_value(3, true)
	construct_ability.can_react = true
	construct_ability.element = "growth"
	construct_ability.modulate = Color("#70ad47")
