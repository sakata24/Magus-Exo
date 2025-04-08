class_name BulletMovement extends Movement

# moves the spell straight. called similarly to move_and_collide minus the collision
func apply_movement(spell: BaseTypeAbility, delta: float):
	spell.position += Vector2(cos(spell.rotation), sin(spell.rotation)) * delta * spell.speed
