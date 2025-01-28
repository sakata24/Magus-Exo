class_name BoltBullet extends Bullet

# grab the ability functions on load
@onready var SunderAbility = preload("res://Abilities/BaseAbilityScripts/SunderAbility.gd").new()

# Initial creation of object on load.
func init(skillDict, castTarget, caster):
	$AnimatedSprite2D.set_sprite_frames(CustomResourceLoader.boltSpriteRes)
	super.init(skillDict, castTarget, caster)

# Handles the reaction effects.
func handle_reaction(reactant: Node2D):
	super(reactant)
	SunderAbility.create_new_reaction(self, reactant)
