# Contains functions related to a Construct ability.
# All Construct abilities should preload this resource.

class_name ConstructAbility extends BaseTypeAbility

# returns a scene based on the type of reaction
func get_reaction_scene(reactant_element: String) -> Node2D:
	match reactant_element:
		"sunder": return SkillSceneHandler.get_scene_by_name("shatter")
		"entropy": return SkillSceneHandler.get_scene_by_name("discharge")
		"growth": return SkillSceneHandler.get_scene_by_name("overgrowth")
		"flow": return SkillSceneHandler.get_scene_by_name("justice")
		"wither": return SkillSceneHandler.get_scene_by_name("extinction")
		_: return null

func set_run_buffs(this: Node2D, caster: Node2D):
	if caster.current_run_data.construct_ignore_walls and this.element == "construct":
		this.set_collision_mask_value(6, false)
