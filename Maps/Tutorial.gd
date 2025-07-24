class_name Tutorial extends Node2D

var enemy_scene = preload("res://Characters/Enemies/Monster/Monster.tscn")

@onready var dialogue_label = $TutorialHUD/MarginContainer/VBoxContainer/StylizedContainer/MarginContainer2/HBoxContainer/VBoxContainer/DisplayText
@onready var directions_label = $TutorialHUD/MarginContainer/VBoxContainer/StylizedContainer/MarginContainer2/HBoxContainer/VBoxContainer/DirectionsText
@onready var tutorial_hud = $TutorialHUD
@onready var level_handler = get_parent()
@onready var main: Main = get_parent().get_parent()
var tween: Tween

signal dialogue_menu_triggered(menu)
enum {MOVE_STAGE, DONE_MOVE, DASH_STAGE, DONE_DASH, SPELL_STAGE, DONE_SPELL, ENEMY_STAGE, CHEST_STAGE, DONE_CHEST, PLAYER_INFO_STAGE, MURDER_PLAYER}
var spell_slots_used = {
	"Q": false,
	"W": false,
	"E": false,
	"R": false
}
var cur_stage = MOVE_STAGE

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed('Space') and cur_stage == DASH_STAGE:
		cur_stage = DONE_DASH
		print("Done Dash Stage")
		hide_dialogue_hud()
	if cur_stage == SPELL_STAGE:
		if Input.is_action_just_pressed("Q"):
			spell_slots_used["Q"] = true
		elif Input.is_action_just_pressed("W"):
			spell_slots_used["W"] = true
		elif Input.is_action_just_pressed("E"):
			spell_slots_used["E"] = true
		elif Input.is_action_just_pressed("R"):
			spell_slots_used["R"] = true
	var all_keys_used = true
	for key_used in spell_slots_used.keys():
		all_keys_used = all_keys_used and spell_slots_used[key_used]
	if all_keys_used and cur_stage == SPELL_STAGE:
		cur_stage = DONE_SPELL
		hide_dialogue_hud()
		start_enemy_stage()
		print("Done Spell Stage")
	if cur_stage == DONE_CHEST:
		cur_stage = PLAYER_INFO_STAGE
		start_player_info_stage()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("I") and cur_stage == PLAYER_INFO_STAGE:
		cur_stage = MURDER_PLAYER
		print("Done Player Info Stage")
		eliminate_player_stage()

func _ready() -> void:
	call_deferred("on_tutorial_start")

func on_tutorial_start():
	self.connect("dialogue_menu_triggered", main._add_menu)
	await main.get_node("BGHandler").transition(1.5)
	var move_controls = Settings.get_controls_from_event("R-Click")
	display_tutorial_text("... I think I should move that way...", "use " + move_controls + " to move to target area.", 2.0)

func _on_move_tutorial_complete_trigger_body_entered(body: Node2D) -> void:
	if cur_stage == MOVE_STAGE:
		cur_stage = DONE_MOVE
		print("Done Move Stage")
		hide_dialogue_hud()

func _on_dash_tutorial_start_trigger_body_entered(body: Node2D) -> void:
	if cur_stage == DONE_MOVE:
		cur_stage = DASH_STAGE
		var dash_controls = Settings.get_controls_from_event("Space")
		display_tutorial_text("... faster...", "use " + dash_controls + " to dash towards target.", 1.0)

func _on_spell_tutorial_start_trigger_body_entered(body: Node2D) -> void:
	if cur_stage == DONE_DASH:
		cur_stage = SPELL_STAGE
		var spell_controls: String = ""
		for spell_key in ["Q", "W", "E", "R"]:
			spell_controls = spell_controls + Settings.get_controls_from_event(spell_key) + ", "
		spell_controls.substr(0, spell_controls.rfind(",")).strip_edges()
		display_tutorial_text("... i can do..... this?", "use " + spell_controls + " to cast spells.", 1.0)
	elif cur_stage < DONE_DASH:
		# push the player back 50 px
		body.global_position = Vector2(body.global_position.x, body.global_position.y + 50)

func start_enemy_stage():
	cur_stage = ENEMY_STAGE
	var enemy: Monster = enemy_scene.instantiate()
	enemy.connect("give_xp", on_enemy_killed)
	add_child(enemy)
	# reduce the first enemy difficulty
	enemy.speed = enemy.speed/2.0
	enemy.maxHealth = enemy.maxHealth * 0.8
	enemy.health = enemy.health * 0.8
	enemy.my_dmg = 1
	enemy.drop_chance = 1.1
	enemy.global_position = $MonsterSpawnLoc.global_position
	display_tutorial_text("what is that...?", "Slay the enemy!", 2.0)

func on_enemy_killed(none, none_):
	cur_stage = CHEST_STAGE
	hide_dialogue_hud()
	display_tutorial_text("it dropped something.", "Pick up the chest.", 1.0)
	var chest_dropped: UpgradeChest = get_node("UpgradeChest")
	if chest_dropped:
		chest_dropped.connect("body_entered", on_chest_grabbed)
	print("Done Kill Stage")

func on_chest_grabbed(body: Node2D):
	cur_stage = DONE_CHEST
	hide_dialogue_hud()
	print("Done Chest Stage")

func start_player_info_stage():
	hide_dialogue_hud()
	var player_info_controls = Settings.get_controls_from_event("I")
	await get_tree().create_timer(0).timeout
	display_tutorial_text("I feel something different.", "Press " + player_info_controls + " to check your info.", 1.0)

func eliminate_player_stage():
	hide_dialogue_hud()
	print("End of tutorial")
	display_tutorial_text("!!!!!!!!!!!!!!!!!!!!!!!!!!", "die.", 0.5)
	PersistentData.tutorial_complete = true
	SaveLoader.save_game()
	$MurderTimer.start()
	_on_murder_timer_timeout()

func _on_murder_timer_timeout() -> void:
	# taking a page out of mr dark mage's book
	var player_pos = get_tree().get_nodes_in_group("players")[0].global_position
		#Spawn Minions around the player
	for i in (5):
		var rad = deg_to_rad(360/(5) * i - 45)
		var inst: Monster = enemy_scene.instantiate()
		inst.global_position.x = player_pos.x + cos(rad) * 50
		inst.global_position.y = player_pos.y + sin(rad) * 50
		get_parent().add_child(inst)
		# scale the enemies to be hella hard and walk thru walls
		inst.droppable = false
		inst.maxHealth *= 5
		inst.health *= 5
		inst.my_dmg = 500
		inst.speed += 75
		inst.scale *= 1.5
		inst.set_collision_mask_value(6, false)
	
func display_tutorial_text(dialogue_to_display: String, directions_to_display: String, time_to_display: float):
	dialogue_label.text = ""
	directions_label.text = ""
	dialogue_label.text = dialogue_to_display
	dialogue_label.visible_ratio = 0
	tween = create_tween()
	tween.tween_property(dialogue_label, "visible_ratio", 1.0, time_to_display)
	tween.tween_callback(func():
		directions_label.text = directions_to_display
		directions_label.visible = true
		)
	tutorial_hud.visible = true
	tween.play()

func hide_dialogue_hud():
	tween.kill()
	dialogue_label.text = ""
	dialogue_label.visible_ratio = 0
	directions_label.text = ""
	directions_label.visible = false
	tutorial_hud.visible = false
