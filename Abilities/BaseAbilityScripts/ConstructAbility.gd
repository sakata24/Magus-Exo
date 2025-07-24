# Contains functions related to a Construct ability.
# All Construct abilities should preload this resource.

class_name ConstructAbility extends BaseTypeAbility

# returns a scene based on the type of reaction
func get_reaction_scene(reactant_element: String) -> Node2D:
	match reactant_element:
		"sunder": return SkillSceneHandler.get_scene_by_name("shatter").instantiate()
		"entropy": return SkillSceneHandler.get_scene_by_name("discharge").instantiate()
		"growth": return SkillSceneHandler.get_scene_by_name("overgrowth").instantiate()
		"flow": return SkillSceneHandler.get_scene_by_name("justice").instantiate()
		"wither": return SkillSceneHandler.get_scene_by_name("extinction").instantiate()
		_: return null

func init(skill_dict: Dictionary, cast_target: Vector2, caster: Node2D):
	# my damage scales with my size
	dmg *= scale.x
	super.init(skill_dict, cast_target, caster)
