class_name FountainSpell extends Spell

# grab the ability functions on load
@onready var FlowAbilityLoad = preload("res://Abilities/BaseAbilityScripts/FlowAbility.gd").new()

# Called when the node enters the scene tree for the first time.
func init(skill_dict: Dictionary, cast_target: Vector2, caster: Node2D):
	super.init(skill_dict, cast_target, caster)
	set_collision_mask_value(2, false)

# after primer timer, fountain pops
func _on_priming_timer_timeout() -> void:
	set_collision_mask_value(2, true)
	$AnimatedSprite2D.animation = "hit"

# Handles the reaction effects.
func handle_reaction(reactant: Node2D):
	super(reactant)
	FlowAbilityLoad.create_new_reaction(self, reactant)
