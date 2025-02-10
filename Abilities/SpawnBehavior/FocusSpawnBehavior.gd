# spawns on a the caster's "focus"
class_name FocusSpawnBehavior extends SpawnBehavior

func apply(spell: BaseTypeAbility, cast_target: Vector2):
	# set position and velocity
	spell.position = spell.spell_caster.focus.global_position
	spell.velocity = (cast_target - spell.position).normalized()
	# aim the projectile to look
	spell.look_at(cast_target)
