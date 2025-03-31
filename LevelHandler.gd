class_name LevelHandler extends Node2D

var boss_levels = [preload("res://Maps/DarkMageMap.tscn")]
var available_boss_levels = [preload("res://Maps/DarkMageMap.tscn")]
var map0 = preload("res://Maps/Map.tscn")
var map1 = preload("res://Maps/Map1.tscn")
var map2 = preload("res://Maps/Map2.tscn")
var map3 = preload("res://Maps/Map3.tscn")
var spawn = preload("res://Maps/Spawn.tscn")
var exit = preload("res://Maps/Exit.tscn")

var current_level = 0
var boss_level_multiple = 5 # default floor multiple boss spawns on
var exit_room = Vector2i()
var roomArray = []
var MAP_SIZE = 2 # sqrt of room amt

@onready var main = get_parent()
@onready var player = main.get_node("Player")

func _ready() -> void:
	for room in get_children():
		init_room_connections(room)
	if Settings.settings_dict["dev_mode"]:
		boss_level_multiple = 2

# called every time a player goes thru the door
func _load_level():
	# inc difficulty when loading
	current_level += 1
	main.get_node("HUD").set_floor(current_level)
	# clean rooms node
	for child in get_children():
		child.queue_free()
	player.position = Vector2i(250, 250)
	player.moving = false
	# init rooms
	if current_level % boss_level_multiple == 0:
		if available_boss_levels.size() <= 0:
			reset_boss_level_array()
		init_boss_room()
	else:
		init_rooms()
	# save the state of the game every level to be persisted
	CustomResourceLoader.save_game()

func reset_boss_level_array():
	available_boss_levels = boss_levels

func init_boss_room():
	var RNG = RandomNumberGenerator.new()
	var random_num = RNG.randi() % boss_levels.size()
	var new_room = available_boss_levels[random_num].instantiate()
	add_child(new_room)
	available_boss_levels.remove_at(random_num)

func init_rooms():
	exit_room = Vector2i(randi_range(1, MAP_SIZE-1), randi_range(1, MAP_SIZE-1))
	for i in range(0,MAP_SIZE):
		for j in range(0,MAP_SIZE):
			var newRoom: Node2D
			if Vector2i(0, 0) == Vector2i(i, j):
				newRoom = spawn.instantiate()
			elif exit_room == Vector2i(i, j):
				newRoom = exit.instantiate()
			else:
				var rand = randi_range(0,3);
				if rand == 0:
					newRoom = map0.instantiate()
				elif rand == 1:
					newRoom = map1.instantiate()
				elif rand == 2:
					newRoom = map2.instantiate()
				else:
					newRoom = map3.instantiate()
			newRoom.position = Vector2(position.x + (496.0 * i), position.y + (496.0 * j))
			
			# block off edges of map
			var tilemap: TileMapLayer = newRoom.get_node("NavigationRegion2D/Layer0")
			# top
			if j == 0:
				for n in range(0, 31):
					if n == 13:
						tilemap.set_cell(Vector2i(n, -1), 0, Vector2i(0, 3), 0)
					elif 13 < n and n < 17:
						tilemap.set_cell(Vector2i(n, -1), 0, Vector2i(1, 0), 0)
					elif n == 17:
						tilemap.set_cell(Vector2i(n, -1), 0, Vector2i(5, 0), 0)
					else:
						tilemap.set_cell(Vector2i(n, -1), 0, Vector2i(8, 7), 0)
			# left
			if i == 0:
				for n in range(0, 31):
					if 12 < n and n < 17:
						tilemap.set_cell(Vector2i(-1, n), 0, Vector2i(0, 1), 0)
					elif n == 17:
						tilemap.set_cell(Vector2i(-1, n), 0, Vector2i(0, 4), 0)
					else:
						tilemap.set_cell(Vector2i(-1, n), 0, Vector2i(8, 7), 0)
			# bottom
			if j == MAP_SIZE-1:
				for n in range(0, 31):
					if n == 13:
						tilemap.set_cell(Vector2i(n, 31), 0, Vector2i(0, 4), 0)
					elif 13 < n and n < 17:
						tilemap.set_cell(Vector2i(n, 31), 0, Vector2i(1, 4), 0)
					elif n == 17:
						tilemap.set_cell(Vector2i(n, 31), 0, Vector2i(5, 4), 0)
					else:
						tilemap.set_cell(Vector2i(n, 31), 0, Vector2i(8, 7), 0)
			# right
			if i == MAP_SIZE-1:
				for n in range(0, 31):
					if 12 < n and n < 17:
						tilemap.set_cell(Vector2i(31, n), 0, Vector2i(5, 1), 0)
					elif n == 17:
						tilemap.set_cell(Vector2i(31, n), 0, Vector2i(5, 4), 0)
					else:
						tilemap.set_cell(Vector2i(31, n), 0, Vector2i(8, 7), 0)
			add_child(newRoom)
			init_room_connections(newRoom)
	# fetch group of monsters on the map and connect their giveXp signals to player
	var monsters = get_tree().get_nodes_in_group("monsters")
	for monster in monsters:
		monster.maxHealth *= current_level
		monster.health *= current_level
		monster.my_dmg *= current_level
		monster.baseDmg *= current_level
		monster.connect("give_xp", Callable(player, "gain_xp"))

func init_room_connections(newRoom: Node2D):
	for node in newRoom.get_children():
		if node is NPC:
			node.connect("button_pressed", Callable(main, "_add_menu"))
		if node is ExitDoor:
			node.connect("load_level", Callable(self, "_load_level"))
