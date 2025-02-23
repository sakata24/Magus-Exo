class_name ChargeAbility extends EntropyAbility

# Initial creation of object on load.
func init(skill_dict: Dictionary, cast_target: Vector2, caster: Node2D):
	$AnimatedSprite2D.set_sprite_frames(CustomResourceLoader.chargeSpriteRes)
	myModifiers.append(CollisionDespawnModifier.new())
	super.init(skill_dict, cast_target, caster)

# Handles the reaction effects.
func handle_reaction(reactant: Node2D):
	super(reactant)
	create_new_reaction(reactant)

func _on_charge_timer_timeout() -> void:
	speed = 1.4 * 300
	dmg = floor(dmg * 1.5)
	scale = scale * 1.5
