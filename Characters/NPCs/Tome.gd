extends "res://Characters/NPCs/NPC.gd"

@onready var ChangeSpellMenu = preload("res://HUDs/SwapSpellMenu.tscn")

func _ready() -> void:
	pass

func _on_button_pressed():
	emit_signal("button_pressed", ChangeSpellMenu.instantiate())
