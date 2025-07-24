# Contains functions related to a Entropy ability.
# All Entropy abilities should preload this resource.

class_name EntropyAbility extends BaseTypeAbility

# returns a scene based on the type of reaction
func get_reaction_scene(reactant_element: String) -> Node2D:
	match reactant_element:
		"sunder": return SkillSceneHandler.get_scene_by_name("blast").instantiate()
		"construct": return SkillSceneHandler.get_scene_by_name("discharge").instantiate()
		"growth": return SkillSceneHandler.get_scene_by_name("life").instantiate()
		"flow": return SkillSceneHandler.get_scene_by_name("erode").instantiate()
		"wither": return SkillSceneHandler.get_scene_by_name("sickness").instantiate()
		_: return null
