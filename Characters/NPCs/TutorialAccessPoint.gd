class_name TutorialAccessPoint extends Node2D

signal redo_tutorial
@onready var level_handler = get_parent().get_parent()

func _ready() -> void:
	call_deferred("connect", "redo_tutorial", level_handler._load_level)

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("L-Click"):
		PersistentData.tutorial_complete = false
		redo_tutorial.emit()
