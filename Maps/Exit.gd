extends Node

signal load_level(diff)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_exit_door_area_body_entered(body):
	if body.get_name() == "Player":
		$ExitLabel.visible = true

func _on_exit_door_area_body_exited(body):
	if body.get_name() == "Player":
		$ExitLabel.visible = false

func _on_exit_door_input_event(viewport, event, shape_idx):
	if event.is_action_pressed('L-Click') and $ExitLabel.visible:
		emit_signal("load_level")

