class_name SuspendAbility extends WitherAbility

func init(skill_dict, cast_target, caster):
	super(skill_dict, cast_target, caster)

func _ready() -> void:
	$TickTimer.connect("timeout", _on_tick_timer_timeout)

func _on_tick_timer_timeout():
	self.set_collision_mask_value(2, !get_collision_mask_value(2))

# Handles the reaction effects.
func handle_reaction(reactant: Node2D):
	super(reactant)
	create_new_reaction(reactant)
