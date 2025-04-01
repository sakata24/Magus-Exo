# abstract class to represent a boss. essentially a monster with additional functionality

class_name Boss extends Monster

func _set_player():
	if get_tree().get_nodes_in_group("players").size() > 0:
		player = get_tree().get_nodes_in_group("players")[0]

func _connect_to_HUD(boss_name: String):
	var hud: HUD = player.get_parent().get_node("HUD")
	connect("health_changed", hud._on_boss_health_change)
	hud.show_boss_bar(boss_name, health)
	emit_signal("health_changed", maxHealth, true)
