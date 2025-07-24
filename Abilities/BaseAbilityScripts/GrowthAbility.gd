# Contains functions related to a Growth ability.
# All Growth abilities should preload this resource.

class_name GrowthAbility extends BaseTypeAbility

# returns a scene based on the type of reaction
func get_reaction_scene(reactant_element: String) -> Node2D:
	match reactant_element:
		"sunder": return SkillSceneHandler.get_scene_by_name("burst").instantiate()
		"entropy": return SkillSceneHandler.get_scene_by_name("life").instantiate()
		"construct": return SkillSceneHandler.get_scene_by_name("overgrowth").instantiate()
		"flow": return SkillSceneHandler.get_scene_by_name("pursuit").instantiate()
		"wither": return SkillSceneHandler.get_scene_by_name("extend").instantiate()
		_: return null

# growth spells have special interactions for each spell with sunder spells
func burst_caused(reactant: SunderAbility):
	pass
