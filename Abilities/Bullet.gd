class_name Bullet extends CharacterBody2D

var abilityID = 0
var speed = 300
var dmg = 10
var timeout = 1.0
var lifetime = 1.0
var cooldown = 0.1
var can_react = true
var size = 1
var reaction_priority = 0
var element
var spell_caster

## constructs the bullet
func init(skill_dict: Dictionary, cast_target: Vector2, caster: Node2D):
	# set instance variables
	abilityID = skill_dict["name"]
	speed = skill_dict["speed"] * speed
	size *= skill_dict["size"]
	dmg *= skill_dict["dmg"]
	timeout *= skill_dict["timeout"]
	lifetime *= skill_dict["lifetime"]
	element = skill_dict["element"]
	reaction_priority = skill_dict["priority"]
	setup_bullet(cast_target, caster)
	# perform operation on spawn
	SkillDataHandler.perform_spawn(self, cast_target, caster)

# sets up relevant variables
func setup_bullet(cast_target: Vector2, caster: Node2D):
	# add it to skill group
	add_to_group("skills")
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
	#if skill_data["type"] == "bullet":
		#instantiated_skill.position = $ProjectilePivot/ProjectileSpawnPos.global_position
		#instantiated_skill.velocity = (cast_target - instantiated_skill.position).normalized()

# run every frame
func _physics_process(delta):
	var collision_data = handle_movement(delta)
	if(collision_data):
		handle_collision(collision_data)

# handles movement of bullet. Standard is a constant speed in a straight line.
func handle_movement(delta) -> KinematicCollision2D:
	return self.move_and_collide(get_velocity().normalized() * delta * speed)

# handles collision data. Standard is differentiate between skills, monsters, and other.
func handle_collision(collision_data: KinematicCollision2D):
	var collider = collision_data.get_collider()
	if collider.get_name() != "Player":
		if collider.is_in_group("skills"):
			handle_reaction(collider)
		elif collider.is_in_group("monsters"):
			handle_enemy_collision(collider)
		else:
			handle_other_collision(collider)

# Handles reaction data. MUST BE OVERWRITTEN OR THE SPELL DOES NO REACTION
func handle_reaction(reactant: Node2D):
	# Disable own collision with other spells to not react.
	set_collision_layer_value(3, false)
	set_collision_mask_value(3, false)

# Handles collision when enemy is hit.
func handle_enemy_collision(enemy: Node2D):
	enemy._hit(self.dmg, self.element, self.element, self.spell_caster)
	despawn()

# Handles all other collisions not implemented (like a wall)
func handle_other_collision(collider):
	despawn()

# end of bullet lifetime
func _on_LifetimeTimer_timeout():
	despawn()

func despawn():
	queue_free()

func _delete():
	queue_free()
