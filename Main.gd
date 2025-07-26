class_name Main extends Node2D

var dead = false
var menus = []
var level = 0
var player_info_scene = preload("res://HUDs/PlayerInfo.tscn")
var player_scene = preload("res://Characters/Player.tscn")
var my_player

# room hex: 25131a
# menu maroon: 460028
# border grey: 464646

func _ready():
	Lobby.player_loaded.rpc_id(1)
	for player in Lobby.players:
		var new_player = player_scene.instantiate()
		new_player.name = str(player)
		add_child(new_player)
		new_player.add_to_group("players")
		
		if multiplayer.get_unique_id() == new_player.name.to_int():
			print("I am the owner of " + str(multiplayer.get_unique_id()))
			my_player = new_player
			# connect hud to player
			$HUD.init(new_player.health, new_player.max_health, PersistentData.equipped_skills)
			PersistentData.connect("equipped_skills_updated", $HUD._set_skills)
			PersistentData.connect("equipped_skills_updated", new_player.set_equipped_skills)
			new_player.connect("moving_to", _show_click)
			new_player.connect("cooling_down", $HUD._set_cd)
			new_player.connect("health_changed", $HUD._set_health)
			new_player.connect("player_died", game_over)
			new_player.connect("cooling_dash", $HUD._set_dash_cd)
			$Menu.connect("skill_changed", _change_skills)
			$Menu.connect("run_ended", kill_player)
			$LevelHandler.connect("change_song", $AudioStreamPlayer.swap_bgm)
			$AudioStreamPlayer.play()
			$LevelHandler.place_player($LevelHandler.get_children())

# called only on server. all players are ready to recieve packets
func start_game():
	var packed_scenes = SkillSceneHandler.get_all_scenes()
	for category in packed_scenes.keys():
		for scene in packed_scenes[category].keys():
			$MultiplayerSpawner.add_spawnable_scene(packed_scenes[category][scene].resource_path)

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
			player_info_menu.update_run_data(my_player.current_run_data)
			get_tree().paused = true
		elif menus[0] is PlayerInfo:
			menus.pop_front().visible = false
			get_tree().paused = false
		else:
			menus.pop_front().visible = false
			var player_info_menu = player_info_scene.instantiate()
			self._add_menu(player_info_menu)
			player_info_menu.update_run_data(my_player.current_run_data)
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
	if my_player.health >= 0:
		my_player.health = 0

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
	my_player.equippedSkills[idx] = new_skill
	my_player.init_skill_cooldowns()
	get_node("HUD/Skill/Ability" + str(idx+1) + "/HBoxContainer/Border/SkillIcon").set_icon(new_skill, key)
