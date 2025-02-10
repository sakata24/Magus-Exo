class_name DecayAbility extends WitherAbility

# Initial creation of object on load.
func init(skill_dict: Dictionary, cast_target: Vector2, caster: Node2D):
	$AnimatedSprite2D.set_sprite_frames(CustomResourceLoader.decaySpriteRes)
	myModifiers.append(CollisionDespawnModifier.new())
	super.init(skill_dict, cast_target, caster)

# Handles the reaction effects.
func handle_reaction(reactant: Node2D):
	super(reactant)
	create_new_reaction(self, reactant)

func handle_enemy_collision(enemy: Node2D):
	enemy.speed *= 0.5
	enemy._hit(self.dmg, self.element, self.element, self.spell_caster)
	attach_slow_timer(0.5, enemy)
	despawn()

func attach_slow_timer(wait_time: float, enemy: Node2D):
	var timer = Timer.new()
	timer.wait_time = wait_time
	# add the function to be run on timeout
	timer.connect("timeout", Callable(func():
		enemy.speed *= 2
		timer.queue_free()))
	enemy.add_sibling(timer)
	timer.start()
