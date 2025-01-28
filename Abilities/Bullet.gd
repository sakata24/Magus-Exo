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

# constructs the bullet
func init(skillDict, castTarget, caster):
	# set variables
	abilityID = skillDict["name"]
	speed = skillDict["speed"] * speed
	size *= skillDict["size"]
	dmg *= skillDict["dmg"]
	timeout *= skillDict["timeout"]
	lifetime *= skillDict["lifetime"]
	element = skillDict["element"]
	if element == "wither":
		$AnimatedSprite2D.set_sprite_frames(CustomResourceLoader.witherSpriteRes)
		$Texture.color = Color("#7030a0")
	add_to_group("skills")
	look_at(castTarget)
	# play the anim
	$AnimatedSprite2D.play()
	$LifetimeTimer.wait_time = lifetime
	scale *= size
	# keep a reference to the caster
	spell_caster = caster
	# perform operation on spawn
	SkillDataHandler.perform_spawn(self, castTarget, caster)

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
	SkillDataHandler.perform_despawn(self, null)

func despawn():
	queue_free()

func _delete():
	queue_free()
