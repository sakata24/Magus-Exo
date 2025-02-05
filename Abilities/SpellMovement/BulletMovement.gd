class_name BulletMovement extends Movement

# moves the spell straight
func move_to(spell: Spell, velocity: Vector2):
	spell.position += velocity
