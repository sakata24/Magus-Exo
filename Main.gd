class_name Main extends Node2D

var dead = false
var menus = []
var level = 0
var player_info_scene = preload("res://HUDs/PlayerInfo.tscn")
var player_scene = preload("res://Characters/Player.tscn")

# room hex: 25131a
# menu maroon: 460028
# border grey: 464646

func _ready():
	# connect hud to player
	$HUD.init($Player.health, $Player.max_health, PersistentData.equipped_skills)
	PersistentData.connect("equipped_skills_updated", $HUD._set_skills)
	PersistentData.connect("equipped_skills_updated", $Player.set_equipped_skills)
	$Player.connect("moving_to", _show_click)
	$Player.connect("cooling_down", $HUD._set_cd)
	$Player.connect("health_changed", $HUD._set_health)
	$Player.connect("player_died", game_over)
	$Player.connect("cooling_dash", $HUD._set_dash_cd)
	$Menu.connect("skill_changed", _change_skills)
	$Menu.connect("run_ended", kill_player)
	$LevelHandler.connect("change_song", $AudioStreamPlayer.swap_bgm)
	$AudioStreamPlayer.play()
	Lobby.player_loaded.rpc_id(1)
	#for player in Lobby.players:
		#var new_player = player_scene.instantiate()
		#new_player.name = str(Lobby.players[player].id)
		#add_child(new_player)

# called only on server. all players are ready to recieve packets
func start_game():
	pass

func _unhandled_input(event):
	if event.is_action_pressed('ui_cancel') and !dead:
		# if no menu open, open the pause menu
		if menus.is_empty():
			menus.push_front($Menu)
			$Menu.visible = true
			# pass along the xp from player to the menu
			get_tree().paused = true
		# if menu is open, close it
		else:
			menus.pop_front().visible = false
			get_tree().paused = false
	elif event.is_action_pressed('I') and !dead:
		if menus.is_empty():
			var player_info_menu: PlayerInfo = player_info_scene.instantiate()
			self._add_menu(player_info_menu)
			player_info_menu.update_run_data($Player.current_run_data)
			get_tree().paused = true
		elif menus[0] is PlayerInfo:
			menus.pop_front().visible = false
			get_tree().paused = false
		else:
			menus.pop_front().visible = false
			var player_info_menu = player_info_scene.instantiate()
			self._add_menu(player_info_menu)
			player_info_menu.update_run_data($Player.current_run_data)
			get_tree().paused = true

func _close_top_menu():
	menus.pop_front().visible = false
	get_tree().paused = false

func _add_menu(menu):
	for child in menu.get_children():
		if child is BaseMenuUI:
			child.connect("close_me", _close_top_menu)
	add_child(menu)
	menus.push_front(menu)
	menu.visible = true
	print("menu.")

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

func _change_skills(idx, new_skill):
	var key
	match idx:
		0: key = "Q"
		1: key = "W"
		2: key = "E"
		3: key = "R"
	$Player.equippedSkills[idx] = new_skill
	$Player.init_skill_cooldowns()
	get_node("HUD/Skill/Ability" + str(idx+1) + "/HBoxContainer/Border/SkillIcon").set_icon(new_skill, key)
