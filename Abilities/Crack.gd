class_name CrackSpell extends Spell

@onready var SunderAbilityLoad = preload("res://Abilities/BaseAbilityScripts/SunderAbility.gd").new()

func init(skill_dict, cast_target, caster):
	super(skill_dict, cast_target, caster)

func handle_reaction(area):
	super(area)
	SunderAbilityLoad.create_new_reaction(area, self)

func _on_timeout_timer_timeout() -> void:
	self.set_collision_mask_value(2, false)
	self.modulate.a = 0.35
	$LifetimeTimer.start()
