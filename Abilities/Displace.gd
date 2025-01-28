class_name DisplaceBullet extends Bullet

# grab the ability functions on load
@onready var FlowAbility = preload("res://Abilities/BaseAbilityScripts/FlowAbility.gd").new()

# Initial creation of object on load.
func init(skillDict, castTarget, caster):
	$AnimatedSprite2D.set_sprite_frames(CustomResourceLoader.displaceSpriteRes)
	super.init(skillDict, castTarget, caster)

# Handles the reaction effects.
func handle_reaction(reactant: Node2D):
	super(reactant)
	FlowAbility.create_new_reaction(self, reactant)

# Handles collision when enemy is hit.
func handle_enemy_collision(enemy: Node2D):
	enemy.can_move = false
	enemy.velocity = self.get_velocity() * 100
	enemy._hit(self.dmg, self.element, self.element, self.spell_caster)
	attach_and_await_stun_timer(0.5, enemy)
	despawn()

func attach_and_await_stun_timer(wait_time: float, enemy: Node2D):
	var timer = Timer.new()
	timer.wait_time = 0.5
	get_parent().add_child(timer)
	timer.start()
	await timer.timeout
	timer.queue_free()
	enemy.can_move = true
	enemy.velocity = Vector2.ZERO
