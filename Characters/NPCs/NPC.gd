class_name NPC extends Node2D

var tooltip_inst = preload("res://HUDs/Tooltip.tscn")
signal button_pressed(shop_data)
var tooltip: Tooltip

# Called when the node enters the scene tree for the first time.
func _ready():
	if not tooltip:
		tooltip = tooltip_inst.instantiate()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_area_2d_body_entered(body):
	if body.get_name() == "Player":
		$Button.visible = true
		if Settings.tooltips_enabled:
			tooltip.visible = true

func _on_area_2d_body_exited(body):
	if body.get_name() == "Player":
		$Button.visible = false
		if Settings.tooltips_enabled:
			tooltip.visible = false

func _on_button_pressed():
	pass
