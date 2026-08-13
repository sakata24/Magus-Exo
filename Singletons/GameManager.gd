extends Node

signal restart_run

func _get_main_scene() -> Node:
	var scene = get_tree().current_scene
	if is_instance_valid(scene) and "my_player" in scene:
		return scene

	var root = get_tree().root
	if is_instance_valid(root):
		for child in root.get_children():
			if is_instance_valid(child) and "my_player" in child:
				return child

	return null

func kill_player() -> void:
	# Clear menus and force player to zero health
	MenuController.close_all_menus()
	var main = _get_main_scene()
	if main and is_instance_valid(main.my_player) and main.my_player.health >= 0:
		main.my_player.health = 0

func game_over() -> void:
	# Centralize game over actions
	MenuController.close_all_menus()
	var main = _get_main_scene()
	if main:
		main.dead = true
		MenuController.player_dead = true
		MenuController.open_menu_by_type(MenuController.MENU.DEATH)
		main.level = 0

func reload_run() -> void:
	MenuController.player_dead = false
	MenuController.close_all_menus()

	var tree = Engine.get_main_loop()
	if not (tree is SceneTree):
		return

	if tree.current_scene != null:
		tree.reload_current_scene()
		return

	var main_scene = ProjectSettings.get_setting("application/run/main_scene")
	if typeof(main_scene) == TYPE_STRING and main_scene != "":
		tree.change_scene_to_file(main_scene)


func change_scene_to_file(path: String) -> void:
	# Centralized wrapper for changing scenes; allows callers to delegate to GameManager
	var tree = Engine.get_main_loop()
	if not (tree is SceneTree):
		return

	tree.change_scene_to_file(path)
