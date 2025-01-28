class_name ChargeBullet extends Bullet

# grab the ability functions on load
@onready var EntropyAbility = preload("res://Abilities/BaseAbilityScripts/EntropyAbility.gd").new()

# Initial creation of object on load.
func init(skillDict, castTarget, caster):
	$AnimatedSprite2D.set_sprite_frames(CustomResourceLoader.chargeSpriteRes)
	super.init(skillDict, castTarget, caster)

# Handles the reaction effects.
func handle_reaction(reactant: Node2D):
	super(reactant)
	EntropyAbility.create_new_reaction(self, reactant)

func _on_growth_timer_timeout() -> void:
	speed = 1.4 * 300
	dmg = floor(dmg * 1.5)
	scale = scale * 1.5
