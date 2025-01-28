class_name RockBullet extends Bullet

# grab the ability functions on load
@onready var ConstructAbility = preload("res://Abilities/BaseAbilityScripts/ConstructAbility.gd").new()

# Initial creation of object on load.
func init(skillDict, castTarget, caster):
	$AnimatedSprite2D.set_sprite_frames(CustomResourceLoader.rockSpriteRes)
	super.init(skillDict, castTarget, caster)

# Handles the reaction effects.
func handle_reaction(reactant: Node2D):
	super(reactant)
	ConstructAbility.create_new_reaction(self, reactant)
