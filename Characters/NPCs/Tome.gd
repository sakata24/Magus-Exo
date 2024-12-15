extends "res://Characters/NPCs/NPC.gd"



func _ready() -> void:
	pass

func _on_button_pressed():
	emit_signal("button_pressed", $ChangeSpells)
