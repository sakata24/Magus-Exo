# Contains functions related to a Wither ability.
# All Wither abilities should preload this resource.

class_name WitherAbility extends BaseTypeAbility

# returns a scene based on the type of reaction
func get_reaction_scene(reactant_element: String) -> Node2D:
	match reactant_element:
		"sunder": return SkillSceneHandler.get_scene_by_name("singularity").instantiate()
		"entropy": return SkillSceneHandler.get_scene_by_name("sickness").instantiate()
		"construct": return SkillSceneHandler.get_scene_by_name("extinction").instantiate()
		"growth": return SkillSceneHandler.get_scene_by_name("extend").instantiate()
		"flow": return SkillSceneHandler.get_scene_by_name("swarm").instantiate()
		_: return null
