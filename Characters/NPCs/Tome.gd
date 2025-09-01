class_name TomeNPC extends NPC

@onready var ChangeSpellMenu = preload("res://HUDs/SwapSpellMenu.tscn")

func _ready() -> void:
	tooltip = $Tooltip
	tooltip.change_title("Codex:")
	tooltip.change_text("Browse owned spells and equip the ones you want.")
	super()

func _on_button_pressed():
	emit_signal("button_pressed", ChangeSpellMenu.instantiate())
