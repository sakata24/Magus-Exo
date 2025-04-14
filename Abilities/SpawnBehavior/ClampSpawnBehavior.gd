class_name ClampSpawnBehavior extends SpawnBehavior

func apply(spell: BaseTypeAbility, cast_target: Vector2):
	spell.position = spell.spell_caster.position
	spell.look_at(cast_target)
