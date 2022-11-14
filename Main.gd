extends Node2D

func _ready():
	# fetch group of monsters on the map and connect their giveXp signals to player
	var monsters = $Map.get_tree().get_nodes_in_group("monsters")
	for monster in monsters:
		monster.connect("giveXp", $Player, "gain_xp")
	
	# connect hud to player
	$HUD/HealthLabel.text = ("Health: " + str($Player.health))
	$HUD/EXPLabel.text = ("EXP: " + str($Player.xp) + " /" + str($Player.currentXpThreshold))
	$HUD/EquippedSkills.text = ("Q: " + str(UniversalSkills.skillArr[$Player.equippedSkills[0]][0]) + "\n\n" + "W: " + str(UniversalSkills.skillArr[$Player.equippedSkills[1]][0]) + "\n\n" + "E: " + str(UniversalSkills.skillArr[$Player.equippedSkills[2]][0]) + "\n\n" + "R: " + str(UniversalSkills.skillArr[$Player.equippedSkills[3]][0]))
	$Player.connect("gained_xp", $HUD, "_set_xp")
	$Player.connect("level_up", $HUD, "_set_lvl")


func _unhandled_input(event):
	if event.is_action_pressed('ui_cancel'):
		$Menu.visible = !$Menu.visible
		get_tree().paused = !get_tree().paused
