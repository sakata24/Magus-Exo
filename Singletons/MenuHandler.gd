extends Node

enum MENU {
	PAUSE,
	SELECTION,
	SETTINGS,
	DEATH,
	SHOP,
	CHANGE_SPELLS,
	PLAYER_INFO
}

var menus = {
	MENU.PAUSE: load("res://HUDs/PauseMenu.tscn"),
	MENU.SELECTION: load("res://HUDs/Selection.tscn"),
	MENU.SETTINGS: load("res://HUDs/Settings.tscn"),
	MENU.DEATH: load("res://HUDs/Death.tscn"),
	MENU.SHOP: load("res://HUDs/Shop.tscn"),
	MENU.CHANGE_SPELLS: load("res://HUDs/ChangeSpells.tscn"),
	MENU.PLAYER_INFO: load("res://HUDs/PlayerInfo.tscn")
}

var active_menus = []
var player_dead = false:
	set(new_value):
		player_dead = new_value

signal new_menu_added(new_menu)

func _ready() -> void:
	menus[MENU.PAUSE].connect("kill_player", _clear_menus)
	# to prevent null calls, and prevent cyclical references on preload
	for key in menus:
		menus[key] = menus[key].instantiate()

func _unhandled_input(event):
	if event.is_action_pressed('ui_cancel') and !player_dead:
		# if no menu open, open the pause menu
		if active_menus.is_empty():
			active_menus.push_front(menus[MENU.PAUSE])
			new_menu_added.emit(menus[MENU.PAUSE])
			# pass along the xp from player to the menu
			#get_tree().paused = true
		# if menu is open, close it
		else:
			_clear_menus()

func show_player_info(player_data):
	if !player_dead:
		if active_menus.is_empty():
			menus[MENU.PLAYER_INFO].update_run_data(player_data)
			active_menus.push_front(menus[MENU.PLAYER_INFO])
			new_menu_added.emit(menus[MENU.PLAYER_INFO])
		else:
			_clear_menus()

func _close_top_menu():
	var top_menu = active_menus.pop_front()
	top_menu.get_parent().remove_child(top_menu)

func _add_menu(new_menu):
	for child in new_menu.get_children():
		if child is BaseMenuUI:
			child.connect("close_me", _close_top_menu)
	new_menu_added.emit(new_menu)
	active_menus.push_front(new_menu)
	print("menu.")

func _clear_menus():
	for menu in active_menus:
		menu.get_parent().remove_child(menu)
	active_menus.clear()
