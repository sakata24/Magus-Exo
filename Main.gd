extends Node2D

var map0 = preload("res://Maps/Map.tscn")
var map1 = preload("res://Maps/Map1.tscn")
var map2 = preload("res://Maps/Map2.tscn")
var roomArray = []
var MAP_SIZE = 2 # amt of rooms

func _ready():
	# connect hud to player
	$HUD.init($Player.health,$Player.maxHealth,str($Player.xp), str($Player.currentXpThreshold),str($Player.equippedSkills[0]),str($Player.equippedSkills[1]),str($Player.equippedSkills[2]),str($Player.equippedSkills[3]))
	$Player.connect("gained_xp", Callable($HUD, "_set_xp"))
	$Player.connect("level_up", Callable(self, "_leveled_up"))
	$Player.connect("moving_to", Callable(self, "_show_click"))
	$Player.connect("cooling_down", Callable($HUD, "_set_cd"))
	$Player.connect("player_hit", Callable($HUD, "_set_health"))
	init_rooms()

func init_rooms():
	for i in range(0,MAP_SIZE):
		for j in range(0,MAP_SIZE):
			var newRoom
			var rand = randi_range(0,2);
			if rand == 0:
				newRoom = map0.instantiate()
			elif rand == 1:
				newRoom = map1.instantiate()
			else:
				newRoom = map2.instantiate()
			newRoom.position = Vector2(position.x + (496.0 * i), position.y + (496.0 * j))
			
			# block off edges of map
			var tilemap = newRoom.get_node("NavigationRegion2D/TileMap")
			var tileset = tilemap.get_tileset()
			# top
			if j == 0:
				for n in range(-1, 2):
					tilemap.set_cell(0, Vector2i(15 + n, 0), 0, Vector2i(1, 0))
					tilemap.set_cell(0, Vector2i(15 + n, 1), 0, Vector2i(2, 1))
			# left
			if i == 0:
				for n in range(-2, 2):
					tilemap.set_cell(0, Vector2i(0, 15 + n), 0, Vector2i(0, 1))
				for n in range(-1, 2):
					tilemap.set_cell(0, Vector2i(1, 15 + n), 0, Vector2i(1, 2))
			# bottom
			if j == MAP_SIZE-1:
				for n in range(-1, 2):
					tilemap.set_cell(0, Vector2i(15 + n, 30), 0, Vector2i(1, 4))
					tilemap.set_cell(0, Vector2i(15 + n, 29), 0, Vector2i(2, 3))
			# right
			if i == MAP_SIZE-1:
				for n in range(-2, 2):
					tilemap.set_cell(0, Vector2i(30, 15 + n), 0, Vector2i(5, 1))
				for n in range(-1, 2):
					tilemap.set_cell(0, Vector2i(29, 15 + n), 0, Vector2i(4, 2))
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
