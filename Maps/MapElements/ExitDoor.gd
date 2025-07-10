class_name ExitDoor extends Node2D

signal load_level(diff)

func _ready():
	var interact_keys = ""
	for event in InputMap.action_get_events("L-Click"):
		interact_keys += event.as_text()
	$Tooltip.change_text("Interact with " + interact_keys + " to continue.")
	$Tooltip.change_title("Exit Door:")

func _on_exit_door_area_body_entered(body):
	if body.get_name() == "Player":
		$ExitLabel.visible = true
		if Settings.tooltips_enabled:
			$Tooltip.visible = true

func _on_exit_door_area_body_exited(body):
	if body.get_name() == "Player":
		$ExitLabel.visible = false
		if Settings.tooltips_enabled:
			$Tooltip.visible = false

func _on_exit_door_input_event(viewport, event, shape_idx):
	if event.is_action_pressed('L-Click') and $ExitLabel.visible:
		emit_signal("load_level")
