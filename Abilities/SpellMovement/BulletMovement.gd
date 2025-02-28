class_name BulletMovement extends Movement

# moves the spell straight. called similarly to move_and_collide minus the collision
func move_to(spell: BaseTypeAbility, velocity: Vector2):
	spell.position += velocity
