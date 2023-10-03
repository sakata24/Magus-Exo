extends CanvasLayer


func _ready():
	pass

func _set_xp(xp, max_xp):
	$MarginContainer/VBoxContainer/EXPLabel.text = ("EXP: " + str(xp) + "/" + str(max_xp))
	$EXPBar.max_value = max_xp
	$EXPBar.value = xp

func _set_lvl(lvl):
	$MarginContainer/VBoxContainer/HBoxContainer/LVLLabel.text = ("Level: " + str(lvl))
