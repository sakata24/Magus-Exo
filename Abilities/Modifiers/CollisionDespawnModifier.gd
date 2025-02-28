class_name CollisionDespawnModifier extends Modifier

func apply(spell: BaseTypeAbility):
	# connect body_entered signal to a function that will first perform normal actions, then despawn when colliding with a body
	spell.connect("body_entered", func(body): 
		spell.despawn())
