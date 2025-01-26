class_name CrackSpell extends Spell

@onready var SunderAbility = preload("res://Abilities/BaseAbilityScripts/SunderAbility.gd").new()

# Called when the node enters the scene tree for the first time.
func _ready():
	dmg = 30
	cooldown = 1.5

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_TimeoutTimer_timeout():
	self.set_collision_mask_value(2, false)
	self.modulate.a = 0.35
	$LifetimeTimer.start()

func _on_area_entered(area):
	if area.name == "SpellBody":
		set_collision_layer_value(3, false)
		set_collision_mask_value(3, false)
		SunderAbility.create_new_reaction(area, self)
