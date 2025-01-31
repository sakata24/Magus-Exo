class_name FissureSpell extends Spell

func init(skill_dict, cast_target, caster):
	super(skill_dict, cast_target, caster)
	set_angle_and_position(cast_target, caster.global_position)

# sets the angle and position of the spell
func set_angle_and_position(cast_target: Vector2, caster_position: Vector2):
	var offset = (cast_target - caster_position).normalized() * 58
	self.position = caster_position + offset
	self.look_at(cast_target)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_tick_timer_timeout() -> void:
	self.set_collision_mask_value(2, !get_collision_mask_value(2))
	$TimeoutTimer.start()
