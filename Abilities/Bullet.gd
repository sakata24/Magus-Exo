class_name Bullet extends Spell

# sets up relevant variables
func setup_spell(cast_target: Vector2, caster: Node2D):
	# add it to skill group
	add_to_group("skills")
	# set position and velocity
	position = caster.get_node("ProjectilePivot/ProjectileSpawnPos").global_position
	velocity = (cast_target - position).normalized()
	# aim the projectile to look
	look_at(cast_target)
	# play the anim
	$AnimatedSprite2D.play()
	# set the lifetime of the bullet and start it
	$LifetimeTimer.wait_time = lifetime
	$LifetimeTimer.start()
	# set the bullet size
	scale *= size
	# keep a reference to the caster
	spell_caster = caster

# Handles all other collisions not implemented (like a wall)
func handle_other_interaction(collider):
	despawn()

func _delete():
	queue_free()
