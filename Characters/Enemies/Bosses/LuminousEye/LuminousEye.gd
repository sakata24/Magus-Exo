class_name LuminousEye extends Boss

func _ready():
	cc_immune = true
	# can i drop upgrades
	droppable = false
	maxHealth = 500
	add_to_group("monsters")
	await call_deferred("_set_player")
	_connect_to_HUD("Photonis, the Luminous Eye")
