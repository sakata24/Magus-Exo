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
	MENU.PAUSE: preload("res://HUDs/PauseMenu.tscn").instantiate(),
	MENU.SELECTION: preload("res://HUDs/Selection.tscn").instantiate(),
	MENU.SETTINGS: preload("res://HUDs/Settings.tscn").instantiate(),
	MENU.DEATH: preload("res://HUDs/Death.tscn").instantiate(),
	MENU.SHOP: preload("res://HUDs/Shop.tscn").instantiate(),
	MENU.CHANGE_SPELLS: preload("res://HUDs/ChangeSpells.tscn").instantiate(),
	MENU.PLAYER_INFO: preload("res://HUDs/PlayerInfo.tscn").instantiate()
}

var active_menus = []
var player_dead = false:
	set(new_value):
		player_dead = new_value

signal new_menu_added(new_menu)

func _unhandled_input(event):
	if event.is_action_pressed('ui_cancel') and !player_dead:
		# if no menu open, open the pause menu
		if menus.is_empty():
			menus.push_front($Menu)
			new_menu_added.emit(menus[MENU.SETTINGS])
			# pass along the xp from player to the menu
			get_tree().paused = true
		# if menu is open, close it
		else:
			_clear_menus()

func show_player_info(player_data):
	if !player_dead:
		if menus.is_empty():
			menus[MENU.PLAYER_INFO].update_run_data(player_data)
			new_menu_added.emit(menus[MENU.PLAYER_INFO])
		else:
			_clear_menus()

func _close_top_menu():
	var top_menu = menus.pop_front()
	top_menu.visible = false
	top_menu.get_parent().remove_child(top_menu)
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
		menu.get_parent().remove_child(menu)
	menus.clear()
	get_tree().paused = false
