class_name Main
extends Node2D

var dead = false
var level = 0
var player_info_scene = preload("res://HUDs/PlayerInfo.tscn")
var player_scene = preload("res://Characters/Player.tscn")
var level_handler_script = preload("res://LevelHandler.gd")
var level_handler: Node2D
@onready var sfx_player: SFXAudioStreamPlayer = $SFXAudioStreamPlayer
var my_player

# room hex: 25131a
# menu maroon: 460028
# border grey: 464646

func _ready():
	_setup_player()
	_bind_hud_to_player()
	_bind_menu_signals()
	_setup_audio()
	_setup_level_handler()

func _setup_player() -> void:
	my_player = player_scene.instantiate()
	add_child(my_player)

func _bind_hud_to_player() -> void:
	$HUD.init(my_player.health, my_player.max_health, PersistentData.equipped_skills)
	PersistentData.connect("equipped_skills_updated", $HUD._set_skills)
	PersistentData.connect("equipped_skills_updated", my_player.set_equipped_skills)
	my_player.connect("moving_to", _show_click)
	my_player.connect("cooling_down", $HUD._set_cd)
	my_player.connect("health_changed", $HUD._set_health)
	my_player.connect("player_died", Callable(GameManager, "game_over"))
	my_player.connect("cooling_dash", $HUD._set_dash_cd)

func _bind_menu_signals() -> void:
	MenuController.connect("new_menu_added", add_child)
	# connect pause menu signals via the controller instance
	if is_instance_valid(MenuController) and MenuController.menus.has(MenuController.MENU.PAUSE):
		MenuController.menus[MenuController.MENU.PAUSE].connect("skill_changed", _change_skills)
		# delegate kill_player to the GameManager
		MenuController.menus[MenuController.MENU.PAUSE].connect("kill_player", Callable(GameManager, "kill_player"))

func _setup_audio() -> void:
	AudioController.setup_for_scene(self)

func _setup_level_handler() -> void:
	level_handler = Node2D.new()
	level_handler.set_script(level_handler_script)
	level_handler.connect("change_song", Callable(AudioController, "swap_bgm"))
	add_child(level_handler)

func _setup_game_manager() -> void:
	# GameManager is an autoload singleton; no local setup needed.
	pass

# called only on server. all players are ready to recieve packets
func start_game():
	pass

func _show_click():
	$ClickAnimation.global_position = get_global_mouse_position()
	$ClickAnimation.set_frame(0)
	$ClickAnimation.visible = true
	$ClickAnimation.play()

func _on_click_animation_animation_finished():
	$ClickAnimation.visible = false

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
