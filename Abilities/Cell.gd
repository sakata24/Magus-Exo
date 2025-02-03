class_name CellBullet extends Bullet

# grab the ability functions on load
@onready var GrowthAbilityLoad = preload("res://Abilities/BaseAbilityScripts/GrowthAbility.gd").new()

# Initial creation of object on load.
func init(skill_dict: Dictionary, cast_target: Vector2, caster: Node2D):
	$AnimatedSprite2D.set_sprite_frames(CustomResourceLoader.cellSpriteRes)
	super.init(skill_dict, cast_target, caster)

# Increases the scale of this ability
func increase_scale(growth_float: float):
	scale += Vector2(growth_float, growth_float)

# Increase the dmg of this ability
func increase_dmg(growth_dmg: int):
	dmg += growth_dmg

# Handles the reaction effects.
func handle_reaction(reactant: Node2D):
	super(reactant)
	GrowthAbilityLoad.create_new_reaction(self, reactant)

# Called every time the growth timer is triggered
func _on_growth_timer_timeout() -> void:
	increase_scale(0.2)
	increase_dmg(1)
