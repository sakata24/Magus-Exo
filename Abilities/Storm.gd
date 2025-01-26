class_name StormSpell extends Spell

var EntropyAbility = preload("res://Abilities/BaseAbilityScripts/EntropyAbility.gd")

# Called when the node enters the scene tree for the first time.
func _ready():
	dmg = 20
	cooldown = 2.5

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_SpellBody_body_entered(body):
	if body.name != "Player":
		if body.is_in_group("skills"):
			set_collision_layer_value(3, false)
			set_collision_mask_value(3, false)
			SkillDataHandler.perform_reaction(body, self)

func _on_TimeoutTimer_timeout():
	# Tick dmg every 0.5 initially, depending on amt of bodies in circle tick differently
	if self.has_overlapping_bodies():
		var array = []
		for body in self.get_overlapping_bodies():
			if body.is_in_group("monsters"):
				array.push_back(body)
		if not array.is_empty():
			var enemy = array[randi() % array.size()]
			enemy._hit(floor(dmg/(array.size()+1)), "entropy", "construct", spellCaster)
			$TimeoutTimer.wait_time = (0.9/(array.size()+1))
	# Only start after changing wait time
	$TimeoutTimer.start()
