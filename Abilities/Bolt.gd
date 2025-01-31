class_name BoltBullet extends Bullet

# grab the ability functions on load
@onready var SunderAbility = preload("res://Abilities/BaseAbilityScripts/SunderAbility.gd").new()

# Initial creation of object on load.
func init(skill_dict: Dictionary, cast_target: Vector2, caster: Node2D):
	$AnimatedSprite2D.set_sprite_frames(CustomResourceLoader.boltSpriteRes)
	super.init(skill_dict, cast_target, caster)

# Handles the reaction effects.
func handle_reaction(reactant: Node2D):
	super(reactant)
	SunderAbility.create_new_reaction(self, reactant)
