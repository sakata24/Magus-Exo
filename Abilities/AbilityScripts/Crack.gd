class_name CrackAbility extends SunderAbility

func init(skill_dict, cast_target, caster):
	super(skill_dict, cast_target, caster)
	self.global_position = caster.global_position

# Handles the reaction effects.
func handle_reaction(reactant: Node2D):
	super(reactant)
	create_new_reaction(reactant)

func _on_timeout_timer_timeout() -> void:
	self.set_collision_mask_value(2, false)
	self.modulate.a = 0.35
	$LifetimeTimer.start()
