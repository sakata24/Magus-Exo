class_name DisplaceBullet extends Bullet

# grab the ability functions on load
@onready var FlowAbilityLoad = preload("res://Abilities/BaseAbilityScripts/FlowAbility.gd").new()

# Initial creation of object on load.
func init(skill_dict: Dictionary, cast_target: Vector2, caster: Node2D):
	$AnimatedSprite2D.set_sprite_frames(CustomResourceLoader.displaceSpriteRes)
	super.init(skill_dict, cast_target, caster)

# Handles the reaction effects.
func handle_reaction(reactant: Node2D):
	super(reactant)
	FlowAbilityLoad.create_new_reaction(self, reactant)

# Handles collision when enemy is hit.
func handle_enemy_collision(enemy: Node2D):
	enemy.can_move = false
	enemy.velocity = self.get_velocity() * 100
	enemy._hit(self.dmg, self.element, self.element, self.spell_caster)
	attach_and_await_stun_timer(0.5, enemy)
	despawn()

# create a timer and add to unstun the enemy
func attach_and_await_stun_timer(wait_time: float, enemy: Node2D):
	var timer = Timer.new()
	timer.wait_time = wait_time
	# add the function to be run on timeout
	timer.connect("timeout", Callable(func():
		enemy.can_move = true
		enemy.velocity = Vector2.ZERO
		timer.queue_free()))
	enemy.add_sibling(timer)
	timer.start()
