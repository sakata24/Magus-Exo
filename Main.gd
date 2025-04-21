extends Node2D

var dead = false
var menus = []
var level = 0

# room hex: 25131a

func _ready():
	# connect hud to player
	$HUD.init($Player.health,$Player.max_health,str($Player.equippedSkills[0]),str($Player.equippedSkills[1]),str($Player.equippedSkills[2]),str($Player.equippedSkills[3]))
	$Player.connect("moving_to", Callable(self, "_show_click"))
	$Player.connect("cooling_down", Callable($HUD, "_set_cd"))
	$Player.connect("player_hit", Callable($HUD, "_set_health"))
	$Player.connect("player_died", Callable(self, "game_over"))
	$Player.connect("cooling_dash", Callable($HUD, "_set_dash_cd"))
	$Menu.connect("skill_changed", Callable(self, "_change_skills"))
	$Menu.connect("run_ended", kill_player)
	$AudioStreamPlayer.play()

func _unhandled_input(event):
	if event.is_action_pressed('ui_cancel') and !dead:
		# if no menu open, open the pause menu
		if menus.is_empty():
			menus.push_front($Menu)
			$Menu.visible = true
			# pass along the xp from player to the menu
			$Menu.update_exp_count(PersistentData.sunder_xp, PersistentData.entropy_xp, PersistentData.construct_xp, PersistentData.growth_xp, PersistentData.flow_xp, PersistentData.wither_xp)
			get_tree().paused = true
		# if menu is open, close it
		else:
			menus.pop_front().visible = false
			get_tree().paused = false

func _add_menu(menu):
	add_child(menu)
	menus.push_front(menu)
	menu.visible = true

func _clear_menus():
	for menu in menus:
		menu.visible = false
	menus.clear()
	get_tree().paused = false

func _show_click():
	$ClickAnimation.global_position = get_global_mouse_position()
	$ClickAnimation.set_frame(0)
	$ClickAnimation.visible = true
	$ClickAnimation.play()

func _on_click_animation_animation_finished():
	$ClickAnimation.visible = false

func kill_player():
	_clear_menus()
	if $Player.health >= 0:
		$Player.health = 0

func game_over():
	# clear menus
	_clear_menus()
	# make dead
	dead = true
	$Death.setup()
	$Death.visible = true
	# reset difficulty
	level = 0

func _change_skills(idx, newSkill):
	print("update skils")
	var key
	match idx:
		0: key = "Q"
		1: key = "W"
		2: key = "E"
		3: key = "R"
	$Player.equippedSkills[idx] = newSkill
	$Player.init_skill_cooldowns()
	get_node("HUD/Skill/Ability" + str(idx+1) + "/HBoxContainer/SkillMargin/SkillIcon").set_icon(newSkill, key)

func despawn_light():
	var tween = create_tween()
	tween.tween_property($CanvasModulate, "color", Color(1,1,1,1), 2)
	tween.parallel().tween_property($Player/PointLight2D, "modulate", Color(1,1,1,0), 2)
	await tween.finished
	$CanvasModulate.visible = false
	$CanvasModulate.color = Color(0,0,0,1)
	$Player/PointLight2D.visible = false
	$Player/PointLight2D.modulate = Color(1,1,1,1)
