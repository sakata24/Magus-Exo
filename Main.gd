extends Node2D

var map0 = preload("res://Maps/Map.tscn")
var map1 = preload("res://Maps/Map1.tscn")
var map2 = preload("res://Maps/Map2.tscn")
var map3 = preload("res://Maps/Map3.tscn")
var spawn = preload("res://Maps/Spawn.tscn")
var exit = preload("res://Maps/Exit.tscn")
var exit_room = Vector2i()
var roomArray = []
var MAP_SIZE = 4 # sqrt of room amt
var dead = false
var menus = []
var diff = 0

func _ready():
	# connect hud to player
	$HUD.init($Player.health,$Player.maxHealth,str($Player.xp), str($Player.currentXpThreshold),str($Player.equippedSkills[0]),str($Player.equippedSkills[1]),str($Player.equippedSkills[2]),str($Player.equippedSkills[3]))
	$Player.connect("gained_xp", Callable($HUD, "_set_xp"))
	$Player.connect("level_up", Callable(self, "_leveled_up"))
	$Player.connect("moving_to", Callable(self, "_show_click"))
	$Player.connect("cooling_down", Callable($HUD, "_set_cd"))
	$Player.connect("player_hit", Callable($HUD, "_set_health"))
	$Player.connect("player_hit", Callable(self, "_check_death"))
	$Player.connect("cooling_dash", Callable($HUD, "_set_dash_cd"))
	$Menu.connect("skill_changed", Callable(self, "_change_skills"))
	#$Rooms/Home/Librarian.connect("button_pressed", Callable(self, "_add_menu"))
	#$Rooms/Home/Armorer.connect("button_pressed", Callable(self, "_add_menu"))
	$Shop.connect("opened", Callable(self, "_add_menu"))
	#$Rooms/Home.connect("load_level", Callable(self, "_load_level"))

func _load_level():
	# inc difficulty when loading
	diff += 1;
	# clean rooms node
	for child in $Rooms.get_children():
		child.queue_free()
	$Player.position = Vector2i(250, 250)
	$Player.moving = false
	# init rooms
	init_rooms()
	

func init_rooms():
	print(diff)
	exit_room = Vector2i(randi_range(1, MAP_SIZE-1), randi_range(1, MAP_SIZE-1))
	for i in range(0,MAP_SIZE):
		for j in range(0,MAP_SIZE):
			var newRoom
			if Vector2i(0, 0) == Vector2i(i, j):
				newRoom = spawn.instantiate()
			elif exit_room == Vector2i(i, j):
				newRoom = exit.instantiate()
				newRoom.connect("load_level", Callable(self, "_load_level"))
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
			var tilemap = newRoom.get_node("NavigationRegion2D/TileMap")
			var tileset = tilemap.get_tileset()
			# top
			if j == 0:
				for n in range(0, 31):
					if n == 13:
						tilemap.set_cell(0, Vector2i(n, -1), 0, Vector2i(0, 3))
					elif 13 < n and n < 17:
						tilemap.set_cell(0, Vector2i(n, -1), 0, Vector2i(1, 0))
					elif n == 17:
						tilemap.set_cell(0, Vector2i(n, -1), 0, Vector2i(5, 0))
					else:
						tilemap.set_cell(0, Vector2i(n, -1), 0, Vector2i(8, 7))
			# left
			if i == 0:
				for n in range(0, 31):
					if 12 < n and n < 17:
						tilemap.set_cell(0, Vector2i(-1, n), 0, Vector2i(0, 1))
					elif n == 17:
						tilemap.set_cell(0, Vector2i(-1, n), 0, Vector2i(0, 4))
					else:
						tilemap.set_cell(0, Vector2i(-1, n), 0, Vector2i(8, 7))
			# bottom
			if j == MAP_SIZE-1:
				for n in range(0, 31):
					if n == 13:
						tilemap.set_cell(0, Vector2i(n, 31), 0, Vector2i(0, 4))
					elif 13 < n and n < 17:
						tilemap.set_cell(0, Vector2i(n, 31), 0, Vector2i(1, 4))
					elif n == 17:
						tilemap.set_cell(0, Vector2i(n, 31), 0, Vector2i(5, 4))
					else:
						tilemap.set_cell(0, Vector2i(n, 31), 0, Vector2i(8, 7))
			# right
			if i == MAP_SIZE-1:
				for n in range(0, 31):
					if 12 < n and n < 17:
						tilemap.set_cell(0, Vector2i(31, n), 0, Vector2i(5, 1))
					elif n == 17:
						tilemap.set_cell(0, Vector2i(31, n), 0, Vector2i(5, 4))
					else:
						tilemap.set_cell(0, Vector2i(31, n), 0, Vector2i(8, 7))
			$Rooms.add_child(newRoom)
	# fetch group of monsters on the map and connect their giveXp signals to player
	var monsters = get_tree().get_nodes_in_group("monsters")
	for monster in monsters:
		monster.maxHealth *= diff
		monster.health *= diff
		monster.myDmg *= diff
		monster.baseDmg *= diff
		print(monster, monster.myDmg)
		monster.connect("giveXp", Callable($Player, "gain_xp"))

func _unhandled_input(event):
	if event.is_action_pressed('ui_cancel') and !dead:
		# if no menu open, open the pause menu
		if menus.is_empty():
			menus.push_front($Menu)
			$Menu.visible = true
			get_tree().paused = true
		# if menu is open, close it
		else:
			menus.pop_front().visible = false
			get_tree().paused = false

func _add_menu(menu):
	add_child(menu)
	menus.push_front(menu)
	menu.visible = true

func _leveled_up(lvl):
	$HUD.set_lvl(lvl)

func _show_click():
	$ClickAnimation.global_position = $ClickAnimation.get_global_mouse_position()
	$ClickAnimation.set_frame(0)
	$ClickAnimation.visible = true
	$ClickAnimation.play()

func _on_click_animation_animation_finished():
	$ClickAnimation.visible = false

func _check_death(newHP, maxHP):
	if newHP <= 0:
		dead = true
		$Death.setup()
		$Death.visible = true
		# reset difficulty
		diff = 0

func _change_skills(idx, newSkill):
	var key
	match idx:
		0: key = "Q"
		1: key = "W"
		2: key = "E"
		3: key = "R"
	$Player.equippedSkills[idx] = newSkill
	$Player.initSkills()
	get_node("HUD/Skill/Ability" + str(idx+1) + "/HBoxContainer/SkillMargin/SkillIcon").set_icon(newSkill, key)


func despawn_light():
	var tween = create_tween()
	tween.tween_property($CanvasModulate, "color", Color(1,1,1,1), 2)
	tween.parallel().tween_property($Player/PointLight2D, "modulate", Color(1,1,1,0), 2)
	await tween.finished
	$CanvasModulate.visible = false
	$CanvasModulate.color = Color(0,0,0,1)
	$Player/PointLight2D.visible = false
	$Player/PointLight2D.modulate = Color(1,1,1,1)
