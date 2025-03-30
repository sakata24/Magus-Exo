extends Node2D

signal load_level()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_ladder_area_body_entered(body):
	if body.get_name() == "Player":
		$EnterLabel.visible = true

func _on_ladder_area_body_exited(body):
	if body.get_name() == "Player":
		$EnterLabel.visible = false

func _on_ladder_input_event(viewport, event, shape_idx):
	if event.is_action_pressed('L-Click') and $EnterLabel.visible:
		emit_signal("load_level")
