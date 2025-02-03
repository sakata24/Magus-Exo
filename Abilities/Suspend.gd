class_name WitherSpell extends Spell

var WitherAbilityLoad = preload("res://Abilities/BaseAbilityScripts/WitherAbility.gd").new()

func init(skill_dict, cast_target, caster):
	super(skill_dict, cast_target, caster)

func _on_TimeoutTimer_timeout():
	self.set_collision_mask_value(2, !get_collision_mask_value(2))

# handles reactions
func handle_reaction(reactant: Node2D):
	super(reactant)
	WitherAbilityLoad.create_new_reaction(self, reactant)
