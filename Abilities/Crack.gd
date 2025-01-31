class_name CrackSpell extends Spell

@onready var SunderAbility = preload("res://Abilities/BaseAbilityScripts/SunderAbility.gd").new()

func handle_reaction(area):
	super(area)
	SunderAbility.create_new_reaction(area, self)

func _on_timeout_timer_timeout() -> void:
	self.set_collision_mask_value(2, false)
	self.modulate.a = 0.35
	$LifetimeTimer.start()
