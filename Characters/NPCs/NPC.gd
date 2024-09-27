extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_area_2d_body_entered(body):
	if body.get_name() == "Player":
		$HBoxContainer/Button.visible = true

func _on_area_2d_body_exited(body):
	if body.get_name() == "Player":
		$HBoxContainer/Button.visible = false

func _on_button_pressed():
	pass
	# figure out how to connect the npc's button to the shop
