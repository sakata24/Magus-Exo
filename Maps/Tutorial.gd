class_name Tutorial extends Node2D

@onready var dialogue_label = $TutorialHUD/MarginContainer/VBoxContainer/StylizedContainer/MarginContainer2/HBoxContainer/VBoxContainer/DisplayText
@onready var tutorial_hud = $TutorialHUD
@onready var level_handler = get_parent()
@onready var main = level_handler.main

signal dialogue_menu_triggered(menu)

func _ready() -> void:
	main.connect("dialogue_menu_triggered", main._add_menu)
	call_deferred(main.get_node("BGHandler").transition, 2.0)

func show_dialogue_hud(new_display_text: String):
	dialogue_label.text = new_display_text
	dialogue_menu_triggered.emit(tutorial_hud)

func hide_dialogue_hud():
	tutorial_hud.visible = false

func on_tutorial_start():
	pass
