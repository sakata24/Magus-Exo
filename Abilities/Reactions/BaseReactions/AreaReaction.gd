# This script is a patchwork method of multiple inheritance.
# Some reactions are NOT Area2Ds, and some are. This allows the reaction that inherits from Area2D to inherit from this class and still inherit from the Reaction class.

class_name AreaReaction extends Area2D

@onready var ReactionScript = preload("res://Abilities/Reactions/BaseReactions/Reaction.gd").new()

func init(reaction_components: Dictionary):
	ReactionScript.init(reaction_components)

func spawn_reaction_name(reaction_name: String, origin_spell: Node2D, dmg_color_1: Color, dmg_color_2: Color):
	ReactionScript.spawn_reaction_name.rpc(reaction_name, origin_spell, dmg_color_1, dmg_color_2)

# returns a radius of the furthest collision point from the center of the parent
func get_parent_bounding_radius() -> int:
	var furthest_distance_from_center
	for point in get_parent().get_node("CollisionPolygon2D").polygon:
		furthest_distance_from_center = max(abs(point.x - self.position.x), abs(point.y - self.position.y))
	return furthest_distance_from_center
