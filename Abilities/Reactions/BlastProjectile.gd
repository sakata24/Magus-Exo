extends CharacterBody2D

var speed = 0
var dmg = 0
var center
var spell_caster

func init(init_speed, init_dmg, init_center, caster):
	speed = init_speed
	dmg = init_dmg
	center = init_center

# called every frame
func _physics_process(delta: float):
	var collision = handle_movement(delta)
	if collision:
		handle_collision(collision)

# Handles movement
func handle_movement(delta: float):
	return move_and_collide((self.global_position - center.global_position).normalized() * delta * speed)

# handles the collisions. Currently only enemy collisions matter
func handle_collision(collision: KinematicCollision2D):
	if collision and collision.get_collider().get_name() != "Player":
		if collision.get_collider().is_in_group("monsters"):
			collision.get_collider()._hit(dmg, "entropy", "sunder", spell_caster)
		despawn()

# despawn me
func despawn():
	queue_free()
