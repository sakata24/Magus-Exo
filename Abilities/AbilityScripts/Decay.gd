class_name DecayAbility extends WitherAbility

# Initial creation of object on load.
func init(skill_dict: Dictionary, cast_target: Vector2, caster: Node2D):
	myModifiers.append(CollisionDespawnModifier.new())
	super.init(skill_dict, cast_target, caster)

# Handles the reaction effects.
func handle_reaction(reactant: Node2D):
	super(reactant)
	create_new_reaction(reactant)

func handle_enemy_collision(enemy: Node2D):
	var damage_object = DamageObject.new(self.dmg, [self.element, self.element], self.spell_caster)
	enemy.speed *= 0.5
	enemy.hit(damage_object)
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
