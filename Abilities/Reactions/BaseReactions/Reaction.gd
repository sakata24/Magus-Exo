class_name Reaction extends Node2D

var reactionText = preload("res://HUDs/ReactionText.tscn")

var caster = null

func init(reaction_components: Dictionary):
	caster = reaction_components["source"].spell_caster

func spawn_reaction_name(name: String, origin_spell: Node2D, dmg_color_1: Color, dmg_color_2: Color):
	var reactionText = reactionText.instantiate()
	reactionText.set_colors(dmg_color_1, dmg_color_2)
	origin_spell.get_parent().add_child(reactionText)
	reactionText.set_value_and_pos(name, origin_spell.position)
