class_name Reaction extends Node2D

var reactionTextScene = preload("res://HUDs/PopupText.tscn")

var caster = null
var parents

func init(reaction_components: Dictionary):
	caster = reaction_components["source"].spell_caster
	parents = reaction_components

func spawn_reaction_name(reaction_name: String, origin_spell: Node2D, dmg_color_1: Color, dmg_color_2: Color):
	var reactionText: PopupText = reactionTextScene.instantiate()
	reactionText.set_colors.rpc(dmg_color_1, dmg_color_2)
	origin_spell.add_sibling(reactionText)
	reactionText.set_value_and_pos.rpc(reaction_name, origin_spell.position)
