class_name CursorSpawnBehavior extends SpawnBehavior

func apply(spell: BaseTypeAbility, cast_target: Vector2):
	spell.position = cast_target
