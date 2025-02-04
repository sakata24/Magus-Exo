class_name RockBullet extends Bullet

# grab the ability functions on load
@onready var ConstructAbilityLoad = preload("res://Abilities/BaseAbilityScripts/ConstructAbility.gd").new()

# Initial creation of object on load.
func init(skill_dict: Dictionary, cast_target: Vector2, caster: Node2D):
	$AnimatedSprite2D.set_sprite_frames(CustomResourceLoader.rockSpriteRes)
	super.init(skill_dict, cast_target, caster)
	ConstructAbilityLoad.init(self, caster)

# Handles the reaction effects.
func handle_reaction(reactant: Node2D):
	super(reactant)
	ConstructAbilityLoad.create_new_reaction(self, reactant)
