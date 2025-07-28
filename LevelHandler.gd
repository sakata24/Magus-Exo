class_name LevelHandler extends Node2D

var boss_levels = [preload("res://Maps/DarkMageMap.tscn"), preload("res://Maps/LuminousEyeMap.tscn")]
var available_boss_levels = [preload("res://Maps/DarkMageMap.tscn"), preload("res://Maps/LuminousEyeMap.tscn")]
var maps = [
	preload("res://Maps/Map.tscn"), 
	preload("res://Maps/Map1.tscn"), 
	preload("res://Maps/Map2.tscn"), 
	preload("res://Maps/Map3.tscn"), 
	preload("res://Maps/Map4.tscn")
]
var spawn = preload("res://Maps/Spawn.tscn")
var exit = preload("res://Maps/Exit.tscn")
var home = preload("res://Maps/Home.tscn")
var tutorial = preload("res://Maps/Tutorial.tscn")

var current_level: int = 0
var boss_level_multiple: int = 3 # default floor multiple boss spawns on
var exit_room: Vector2i = Vector2i() # the location of the room
var roomArray = []
var MAP_SIZE = 3 # sqrt of room amt

signal change_song(song)

@onready var main = get_parent()

@export var initial_level: Node2D # for debugging purposes

func _ready() -> void:
	if get_child_count() <= 0:
		if not PersistentData.tutorial_complete:
			add_child(tutorial.instantiate())
		else:
			add_child(home.instantiate())
	for room in get_children():
		init_room_connections(room)
	if Settings.dev_mode:
		boss_level_multiple = 2

# called every time a player goes thru the door
func _load_level():
	# first, fade to black
	main.get_node("BGHandler").transition(1.5)
	# only if server, create the map
	var new_rooms: Array[Node]
	if multiplayer.is_server():
		cleanup_rooms()
		if not PersistentData.tutorial_complete:
			new_rooms = [tutorial.instantiate()]
			add_child(new_rooms[0])
			place_player(new_rooms)
			return
		# inc difficulty when loading
		current_level += 1
		main.get_node("HUD").set_floor(current_level)
		# init rooms
		if current_level % boss_level_multiple == 0:
			if available_boss_levels.size() <= 0:
				reset_boss_level_array()
			new_rooms = init_boss_room()
		else:
			new_rooms = init_rooms()
			play_song("dungeon_delving")
		# client will then copy the new rooms
		place_player.rpc(new_rooms)
	# save the state of the game every level to be persisted
	SaveLoader.save_game()

@rpc("any_peer", "call_local", "reliable")
func place_player(new_rooms: Array[Node]):
	# move player. must disable cam smoothing for transitioning purposes
	print("placing player " + str(main.my_player) + "... in: " + str(new_rooms))
	main.my_player.moving = false
	main.my_player.my_cam.position_smoothing_enabled = false
	main.my_player.global_position = get_player_spawn(new_rooms)
	main.my_player.move_target = main.my_player.position
	# wait until next frame
	await get_tree().create_timer(0).timeout
	main.my_player.my_cam.call_deferred("set_position_smoothing_enabled", true)

func cleanup_rooms():
	# clean rooms node
	for child in get_children():
		child.queue_free()
	# clear groups
	for spell in get_tree().get_nodes_in_group("spells"):
		spell.queue_free()

func get_player_spawn(rooms: Array) -> Vector2:
	# find where to spawn the player
	for room in rooms: 
		if room.has_node("PlayerSpawnLoc"):
			print("spawning player at: " + str(room.get_node("PlayerSpawnLoc").position))
			return room.get_node("PlayerSpawnLoc").global_position
	# if none, spawn in top left room center
	printerr("Could not find player spawn pos. Spawning in default pos.")
	printerr(rooms)
	return Vector2(250, 250)

func reset_boss_level_array():
	available_boss_levels = boss_levels

func init_boss_room() -> Array[Node]:
	# randomly choose a boss+room to spawn
	var random_num = randi_range(0, available_boss_levels.size()-1)
	var new_room: Node2D = available_boss_levels[random_num].instantiate()
	add_child(new_room)
	# remove it from the array
	available_boss_levels.remove_at(random_num)
	setup_boss_room(new_room)
	return [new_room]

func setup_boss_room(new_room: Node2D):
	for node in new_room.get_children():
		if node is Boss:
			for sig in node.signals:
				match sig:
					"health_changed": node.connect("health_changed", get_parent().get_node("HUD")._on_boss_health_change)
					"boss_dead": node.connect("boss_dead", get_parent().get_node("HUD").hide_boss_bar)
					"blinding_player": 
						node.connect("blinding_player", get_parent().get_node("BGHandler").despawn_light)
						for player in get_tree().get_nodes_in_group("players"):
							node.connect("blinding_player", player.spawn_light)
					"unblinding_player": 
						node.connect("unblinding_player", get_parent().get_node("BGHandler").respawn_light)
						for player in get_tree().get_nodes_in_group("players"):
							node.connect("unblinding_player", player.despawn_light)
			get_parent().get_node("HUD").show_boss_bar(node.boss_name, node.health)
		if node is ExitDoor:
			node.connect("load_level", Callable(self, "_load_level"))

func init_rooms() -> Array[Node]:
	var new_rooms: Array[Node]
	exit_room = Vector2i(randi_range(1, MAP_SIZE-1), randi_range(1, MAP_SIZE-1))
	for i in range(0,MAP_SIZE):
		for j in range(0,MAP_SIZE):
			var newRoom: Node2D
			if Vector2i(0, 0) == Vector2i(i, j):
				newRoom = spawn.instantiate()
			elif exit_room == Vector2i(i, j):
				newRoom = exit.instantiate()
			else:
				var rand = randi_range(0,maps.size() - 1);
				newRoom = maps[rand].instantiate()
			newRoom.position = Vector2(position.x + (496.0 * i), position.y + (496.0 * j))
			
			# block off edges of map
			var tilemap: TileMapLayer = newRoom.get_node("NavigationRegion2D/Layer0")
			# top
			if j == 0:
				for n in range(0, 31):
					if n == 12:
						tilemap.set_cell(Vector2i(n, -1), 0, Vector2i(0, 3), 0)
					elif 12 < n and n < 18:
						tilemap.set_cell(Vector2i(n, -1), 0, Vector2i(1, 0), 0)
					elif n == 18:
						tilemap.set_cell(Vector2i(n, -1), 0, Vector2i(5, 0), 0)
					else:
						tilemap.set_cell(Vector2i(n, -1), 0, Vector2i(8, 7), 0)
			# left
			if i == 0:
				for n in range(0, 31):
					if 11 < n and n < 18:
						tilemap.set_cell(Vector2i(-1, n), 0, Vector2i(0, 1), 0)
					elif n == 18:
						tilemap.set_cell(Vector2i(-1, n), 0, Vector2i(0, 4), 0)
					else:
						tilemap.set_cell(Vector2i(-1, n), 0, Vector2i(8, 7), 0)
			# bottom
			if j == MAP_SIZE-1:
				for n in range(0, 31):
					if n == 12:
						tilemap.set_cell(Vector2i(n, 31), 0, Vector2i(0, 4), 0)
					elif 12 < n and n < 18:
						tilemap.set_cell(Vector2i(n, 31), 0, Vector2i(1, 4), 0)
					elif n == 18:
						tilemap.set_cell(Vector2i(n, 31), 0, Vector2i(5, 4), 0)
					else:
						tilemap.set_cell(Vector2i(n, 31), 0, Vector2i(8, 7), 0)
			# right
			if i == MAP_SIZE-1:
				for n in range(0, 31):
					if 11 < n and n < 18:
						tilemap.set_cell(Vector2i(31, n), 0, Vector2i(5, 1), 0)
					elif n == 18:
						tilemap.set_cell(Vector2i(31, n), 0, Vector2i(5, 4), 0)
					else:
						tilemap.set_cell(Vector2i(31, n), 0, Vector2i(8, 7), 0)
			add_child(newRoom)
			init_room_connections(newRoom)
			new_rooms.append(newRoom)
	return new_rooms

func init_room_connections(newRoom: Node2D):
	for node in newRoom.get_children():
		if node is NPC:
			node.connect("button_pressed", main._add_menu)
		if node is ExitDoor:
			node.connect("load_level", _load_level.rpc)
		if node is Monster:
			for player in get_tree().get_nodes_in_group("players"):
				node.connect("give_xp", player.gain_xp)
				update_monster_scaling(node)

func update_monster_scaling(monster: Monster):
	if monster is Boss:
		monster.maxHealth *= current_level/boss_level_multiple
		monster.health *= current_level/boss_level_multiple
	else:
		monster.maxHealth = monster.maxHealth + (current_level * 10.0)
		monster.health = monster.health + (current_level * 10.0)
		monster.my_dmg += current_level / 2.0
		monster.baseDmg += current_level / 2.0

func play_song(song_name: String):
	emit_signal("change_song", song_name, 1.5)
