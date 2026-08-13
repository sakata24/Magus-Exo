extends Node

# Phase 1: keep the menu stack ownership in one place.
# This isolates menu lifecycle from the wider singleton and makes the
# close/open flow easier to reason about and test.
var active_menus: Array = []

signal new_menu_added(new_menu)

var player_dead: bool = false

# Packed menu scenes mapped by MENU enum value. This used to live in MenuHandler;
# migrating here centralizes menu lifecycle and instantiation.
var menu_scenes = {
	0: load("res://HUDs/PauseMenu.tscn"),
	1: load("res://HUDs/Selection.tscn"),
	2: load("res://HUDs/Settings.tscn"),
	3: load("res://HUDs/Death.tscn"),
	4: load("res://HUDs/Shop.tscn"),
	5: load("res://HUDs/ChangeSpells.tscn"),
	6: load("res://HUDs/PlayerInfo.tscn")
}

enum MENU {
	PAUSE,
	SELECTION,
	SETTINGS,
	DEATH,
	SHOP,
	CHANGE_SPELLS,
	PLAYER_INFO
}

# runtime instances cache (key -> Node)
var menus: Dictionary = {}

func _ready() -> void:
	# instantiate menu scenes and wire common signals once
	for key in menu_scenes:
		var inst = menu_scenes[key].instantiate()
		for child in inst.get_children():
			if child is BaseMenuUI:
				child.connect("close_me", Callable(self, "close_top_menu"))
		menus[key] = inst
	# connect pause kill_player if present
	if menus.has(0):
		menus[0].connect("kill_player", Callable(self, "_on_pause_kill_player"))
	# connect death restart to GameManager if available
	if menus.has(3) and menus[3].has_signal("restart_requested") and not menus[3].is_connected("restart_requested", Callable(GameManager, "reload_run")):
		menus[3].connect("restart_requested", Callable(GameManager, "reload_run"))

	# Ensure the controller receives unhandled input events to manage menu open/close
	set_process_unhandled_input(true)


func _unhandled_input(event):
	# Keep controller's active_menus pruned so is_empty checks are accurate
	_prune_invalid_menus()

	if event.is_action_pressed('ui_cancel') and not player_dead:
		# if no menu open, open the pause menu
		if active_menus.is_empty():
			var pause_menu = _ensure_menu_instance(0)
			if pause_menu == null:
				return
			open_menu(pause_menu)
			return
		# if menu is open, close it
		else:
			close_top_menu()

func _on_pause_kill_player():
	# Compatibility shim: pause menu requested kill -> clear all menus
	close_all_menus()

func _ensure_menu_instance(key):
	if menus.has(key) and is_instance_valid(menus[key]):
		return menus[key]
	if menu_scenes.has(key):
		var inst = menu_scenes[key].instantiate()
		for child in inst.get_children():
			if child is BaseMenuUI:
				child.connect("close_me", Callable(self, "close_top_menu"))
		menus[key] = inst
		if key == 0:
			menus[0].connect("kill_player", Callable(self, "_on_pause_kill_player"))
		if key == 3 and menus[3].has_signal("restart_requested") and not menus[3].is_connected("restart_requested", Callable(GameManager, "reload_run")):
			menus[3].connect("restart_requested", Callable(GameManager, "reload_run"))
		return menus[key]
	return null

func open_menu_by_type(key):
	var inst = _ensure_menu_instance(key)
	if inst != null:
		open_menu(inst)

func show_player_info(player_data):
	# Mirror the previous MenuHandler behavior: open player info menu when not dead.
	if player_dead:
		return
	if active_menus.is_empty():
		var info_menu = _ensure_menu_instance(MenuController.MENU.PLAYER_INFO)
		if info_menu == null:
			return
		# try to call update_run_data if available
		if info_menu.has_method("update_run_data"):
			info_menu.update_run_data(player_data)
		open_menu(info_menu)
	else:
		close_all_menus()


func _prune_invalid_menus() -> void:
	active_menus = active_menus.filter(func(menu):
		return is_instance_valid(menu)
	)

func open_menu(menu: Node) -> void:
	_prune_invalid_menus()
	if menu == null or not is_instance_valid(menu):
		return
	# Open a menu and make it the top of the stack.
	# If it's already present, move it to the front. If another menu
	# was the top, hide that previous top.
	if active_menus.is_empty():
		active_menus.push_front(menu)
		if is_instance_valid(menu):
			menu.visible = true
			# ensure the menu is parented into the current scene so it's visible
			var tree = Engine.get_main_loop()
			if tree is SceneTree and tree.current_scene != null and menu.get_parent() == null:
				tree.current_scene.add_child(menu)
		# notify listeners a new menu became active
		new_menu_added.emit(menu)
		return
	# hide current top
	var current_top = active_menus[0]
	if is_instance_valid(current_top) and current_top != menu:
		current_top.visible = false
	# if menu already exists in stack, remove it first
	if active_menus.has(menu):
		active_menus.erase(menu)
	# insert as new top
	active_menus.insert(0, menu)
	if is_instance_valid(menu):
		menu.visible = true
		var tree = Engine.get_main_loop()
		if tree is SceneTree and tree.current_scene != null and menu.get_parent() == null:
			tree.current_scene.add_child(menu)
	# notify listeners that a menu was added to the stack
	new_menu_added.emit(menu)

func add_menu_in_pos(menu: Node, pos_from_top: int = 1) -> void:
	# Insert `menu` behind the top-most entry (index 0) by default.
	# This lets callers add a menu to the "one-behind-top" position when
	# another menu is already active (useful for Selection menus queued
	# by chests). Keeps the MenuController owning visibility and lifecycle.
	_prune_invalid_menus()
	if menu == null or not is_instance_valid(menu):
		return
	# guard against duplicate references
	if active_menus.has(menu):
		return
	if active_menus.is_empty():
		active_menus.push_front(menu)
		if is_instance_valid(menu):
			menu.visible = true
			var tree = Engine.get_main_loop()
			if tree is SceneTree and tree.current_scene != null and menu.get_parent() == null:
				tree.current_scene.add_child(menu)
		return
	# clamp insertion index between 1 and current size
	var idx = clamp(pos_from_top, 1, active_menus.size())
	active_menus.insert(idx, menu)
	if is_instance_valid(menu):
		menu.visible = false
	# emit that a menu was queued/added
	new_menu_added.emit(menu)

func close_top_menu() -> void:
	_prune_invalid_menus()
	if active_menus.is_empty():
		return
	var top_menu = active_menus.pop_front()
	if is_instance_valid(top_menu) and top_menu.get_parent() != null:
		top_menu.get_parent().remove_child(top_menu)
	# reveal the next menu in the queue, if any
	_prune_invalid_menus()
	if not active_menus.is_empty():
		var next_menu = active_menus[0]
		if is_instance_valid(next_menu):
			next_menu.visible = true
	# keep any lower-priority menus in place; only the topmost entry is closed

func close_all_menus() -> void:
	_prune_invalid_menus()
	for menu in active_menus:
		if menu.get_parent() != null:
			menu.get_parent().remove_child(menu)
	active_menus.clear()
