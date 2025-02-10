class_name CrackAbility extends SunderAbility

func init(skill_dict, cast_target, caster):
	super(skill_dict, cast_target, caster)
	self.global_position = caster.global_position

func handle_reaction(area):
	super(area)
	create_new_reaction(area, self)

func _on_timeout_timer_timeout() -> void:
	self.set_collision_mask_value(2, false)
	self.modulate.a = 0.35
	$LifetimeTimer.start()
