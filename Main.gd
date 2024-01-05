extends Node2D

var map = preload("res://Maps/Map.tscn")
var roomArray = []

func _ready():
	
	# connect hud to player
	$HUD/Health/HealthLabel.text = ("Health: " + str($Player.health))
	$HUD/EXPLabel.text = ("EXP: " + str($Player.xp) + " /" + str($Player.currentXpThreshold))
	$HUD/Skill0/SkillName.text = ("Q: " + str($Player.equippedSkills[0]))
	$HUD/Skill1/SkillName.text = ("W: " + str($Player.equippedSkills[1]))
	$HUD/Skill2/SkillName.text = ("E: " + str($Player.equippedSkills[2]))
	$HUD/Skill3/SkillName.text = ("R: " + str($Player.equippedSkills[3]))
	$Player.connect("gained_xp", Callable($HUD, "_set_xp"))
	$Player.connect("level_up", Callable(self, "_leveled_up"))
	$Player.connect("moving_to", Callable(self, "_show_click"))
	$Player.connect("cooling_down", Callable($HUD, "_set_cd"))
	$Player.connect("cooling_dash", Callable($HUD, "_set_dash_cd"))
	$Player.connect("player_hit", Callable($HUD, "_set_hp"))
	
	for i in range(0,6):
		for j in range(0,6):
			var newRoom = map.instantiate()
			newRoom.position = Vector2(position.x + (816.0 * i), position.y + (816.0 * j))
			$Rooms.add_child(newRoom)
			# fetch group of monsters on the map and connect their giveXp signals to player
			var monsters = newRoom.get_tree().get_nodes_in_group("monsters")
			for monster in monsters:
				monster.connect("giveXp", Callable($Player, "gain_xp"))


func _unhandled_input(event):
	if event.is_action_pressed('ui_cancel'):
		$Menu.visible = !$Menu.visible
		get_tree().paused = !get_tree().paused

func _leveled_up(lvl):
	$HUD.set_lvl(lvl)

func _show_click():
	$ClickAnimation.global_position = $ClickAnimation.get_global_mouse_position()
	$ClickAnimation.set_frame(0)
	$ClickAnimation.visible = true
	$ClickAnimation.play()

func _on_click_animation_animation_finished():
	$ClickAnimation.visible = false

