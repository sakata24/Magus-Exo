extends CanvasLayer


func _ready():
	pass

func _set_xp(xp, max_xp):
	$EXPLabel.text = ("EXP: " + str(xp) + "/" + str(max_xp))

func _set_lvl(lvl):
	$LVLLabel.text = ("Level: " + str(lvl))
