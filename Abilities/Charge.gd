class_name ChargeBullet extends Bullet

# grab the ability functions on load
@onready var EntropyAbility = preload("res://Abilities/BaseAbilityScripts/EntropyAbility.gd").new()

# Initial creation of object on load.
func init(skillDict, castTarget, caster):
	$AnimatedSprite2D.set_sprite_frames(CustomResourceLoader.chargeSpriteRes)
	super.init(skillDict, castTarget, caster)

# physics process is run every frame
func _physics_process(delta: float) -> void:
	var collision_data = handle_movement(delta)
	if(collision_data):
		handle_collision(collision_data)

# Handles movement. Called every frame.
func handle_movement(delta: float) -> KinematicCollision2D:
	return self.move_and_collide(get_velocity().normalized() * delta * speed)

# Handles if a collision occurs. Determines what type of collision.
func handle_collision(collision: KinematicCollision2D):
	var collider = collision.get_collider()
	if collider.get_name() != "Player":
		if collider.is_in_group("skills"):
			handle_reaction(collider)
		elif collider.is_in_group("monsters"):
			handle_enemy_collision(collider)
		else:
			handle_other_collision(collider)

# Handles the reaction effects.
func handle_reaction(reactant: Node2D):
	# Disable own collision with other spells to not react.
	set_collision_layer_value(3, false)
	set_collision_mask_value(3, false)
	EntropyAbility.create_new_reaction(self, reactant)

# Handles collision when enemy is hit.
func handle_enemy_collision(enemy: Node2D):
	enemy._hit(self.dmg, self.element, self.element, self.spell_caster)
	despawn()

# Handles all other collisions not implemented (like a wall)
func handle_other_collision(collider):
	despawn()

func _on_growth_timer_timeout() -> void:
	speed = 1.4 * 300
	dmg = floor(dmg * 1.5)
	scale = scale * 1.5
