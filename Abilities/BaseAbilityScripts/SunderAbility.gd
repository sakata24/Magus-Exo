# Contains functions related to a Sunder ability.
# All Sunder abilities should preload this resource.

class_name SunderAbility extends BaseTypeAbility

# returns a scene based on the type of reaction
func get_reaction_scene(reactant_element: String) -> Node2D:
	match reactant_element:
		"entropy": return SkillSceneHandler.get_scene_by_name("blast").instantiate()
		"construct": return SkillSceneHandler.get_scene_by_name("shatter").instantiate()
		"growth": return null
		"flow": return SkillSceneHandler.get_scene_by_name("break").instantiate()
		"wither": return SkillSceneHandler.get_scene_by_name("singularity").instantiate()
		_: return null
