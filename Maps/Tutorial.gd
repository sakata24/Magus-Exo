class_name Tutorial extends Node2D

@onready var dialogue_label = $TutorialHUD/MarginContainer/VBoxContainer/StylizedContainer/MarginContainer2/HBoxContainer/VBoxContainer/DisplayText
@onready var tutorial_hud = $TutorialHUD
@onready var level_handler = get_parent()
@onready var main: Main = get_parent().get_parent()

signal dialogue_menu_triggered(menu)

func _ready() -> void:
	call_deferred("on_tutorial_start")
	$TutorialHUD/MarginContainer/VBoxContainer/StylizedContainer/MarginContainer2/HBoxContainer/VBoxContainer/ContinueText.text = "press " + Settings.get_controls_from_event("ui_cancel") + " to continue..."

func show_dialogue_hud(new_display_text: String):
	dialogue_label.text = new_display_text
	dialogue_menu_triggered.emit(tutorial_hud)

func hide_dialogue_hud():
	tutorial_hud.visible = false

func on_tutorial_start():
	self.connect("dialogue_menu_triggered", main._add_menu)
	await main.get_node("BGHandler").transition(1.5)
	var move_controls = Settings.get_controls_from_event("R-Click")
	dialogue_label.text = "... I think I should move that way... \n\n" + move_controls + " to move to target area."
	dialogue_menu_triggered.emit(tutorial_hud)
	get_tree().paused = true

#func _unhandled_input(event):
	#if not main.menus.is_empty() and event:
		#main._clear_menus()
