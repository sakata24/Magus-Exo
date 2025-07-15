class_name Tutorial extends Node2D

var enemy_scene = preload("res://Characters/Enemies/Monster/Monster.tscn")

@onready var dialogue_label = $TutorialHUD/MarginContainer/VBoxContainer/StylizedContainer/MarginContainer2/HBoxContainer/VBoxContainer/DisplayText
@onready var directions_label = $TutorialHUD/MarginContainer/VBoxContainer/StylizedContainer/MarginContainer2/HBoxContainer/VBoxContainer/DirectionsText
@onready var tutorial_hud = $TutorialHUD
@onready var level_handler = get_parent()
@onready var main: Main = get_parent().get_parent()

signal dialogue_menu_triggered(menu)
enum {MOVE_STAGE, DONE_MOVE, DASH_STAGE, DONE_DASH, SPELL_STAGE, DONE_SPELL}
var spell_slots_used = {
	"Q": false,
	"W": false,
	"E": false,
	"R": false
}
var cur_stage = MOVE_STAGE

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed('Space') and cur_stage == DASH_STAGE:
		cur_stage += 1
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
		cur_stage += 1
		hide_dialogue_hud()
		start_enemy_stage()
		print("Done Spell Stage")

func _ready() -> void:
	call_deferred("on_tutorial_start")

func on_tutorial_start():
	self.connect("dialogue_menu_triggered", main._add_menu)
	await main.get_node("BGHandler").transition(1.5)
	var move_controls = Settings.get_controls_from_event("R-Click")
	display_tutorial_text("... I think I should move that way...", "use " + move_controls + " to move to target area.", 2.0)

func _on_move_tutorial_complete_trigger_body_entered(body: Node2D) -> void:
	if cur_stage == MOVE_STAGE:
		cur_stage += 1
		print("Done Move Stage")
		hide_dialogue_hud()

func _on_dash_tutorial_start_trigger_body_entered(body: Node2D) -> void:
	if cur_stage == DONE_MOVE:
		cur_stage += 1
		var dash_controls = Settings.get_controls_from_event("Space")
		display_tutorial_text("... faster...", "use " + dash_controls + " to dash towards target.", 1.0)

func _on_spell_tutorial_start_trigger_body_entered(body: Node2D) -> void:
	if cur_stage == DONE_DASH:
		cur_stage += 1
		var spell_controls: String = ""
		for spell_key in ["Q", "W", "E", "R"]:
			spell_controls = spell_controls + Settings.get_controls_from_event(spell_key) + ", "
		spell_controls.substr(0, spell_controls.rfind(",")).strip_edges()
		display_tutorial_text("... i can do..... this?", "use " + spell_controls + " to cast spells.", 1.0)

func start_enemy_stage():
	var enemy: Monster = enemy_scene.instantiate()
	enemy.droppable = false
	# reduce the first enemy difficulty
	enemy.speed = enemy.speed/2.0
	enemy.maxHealth = enemy.maxHealth * 0.8
	enemy.health = enemy.health * 0.8
	enemy.my_dmg = 1
	enemy.connect("give_xp", on_enemy_killed)
	add_child(enemy)
	enemy.global_position = $MonsterSpawnLoc.global_position
	display_tutorial_text("what is that...?", "Slay the monster!", 2.0)

func on_enemy_killed():
	cur_stage += 1
	
func display_tutorial_text(dialogue_to_display: String, directions_to_display: String, time_to_display: float):
	dialogue_label.text = ""
	directions_label.text = ""
	dialogue_label.text = dialogue_to_display
	dialogue_label.visible_ratio = 0
	var tween = create_tween()
	tween.tween_property(dialogue_label, "visible_ratio", 1.0, time_to_display)
	tween.tween_callback(func():
		directions_label.text = directions_to_display
		directions_label.visible = true
		)
	tutorial_hud.visible = true
	tween.play()

func hide_dialogue_hud():
	dialogue_label.text = ""
	directions_label.text = ""
	tutorial_hud.visible = false
