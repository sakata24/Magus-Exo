class_name StormSpell extends Spell

var EntropyAbilityLoad = preload("res://Abilities/BaseAbilityScripts/EntropyAbility.gd").new()

func handle_reaction(reactant: Node2D):
	super(reactant)
	EntropyAbilityLoad.create_new_reaction(self, reactant)

# damage enemies in radius
func _on_timeout_timer_timeout():
	# Tick dmg every 0.5 initially, depending on amt of bodies in circle tick differently
	if self.has_overlapping_bodies():
		var array = []
		for body in self.get_overlapping_bodies():
			if body.is_in_group("monsters"):
				array.push_back(body)
		if not array.is_empty():
			var enemy = array[randi() % array.size()]
			handle_enemy_interaction(enemy)
			$TimeoutTimer.wait_time = (0.9/(array.size()+1))
	# Only start after changing wait time
	$TimeoutTimer.start()

# ignore things entering this spell
func _on_SpellBody_body_entered(body):
	pass
