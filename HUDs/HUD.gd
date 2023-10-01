extends CanvasLayer


func _ready():
	pass

func _set_xp(xp, max_xp):
	$EXPLabel.text = ("EXP: " + str(xp) + "/" + str(max_xp))

func _set_lvl(lvl):
	$LVLLabel.text = ("Level: " + str(lvl))

func _show_click(click):
	$ClickAnimation.to_global(click)
	$ClickAnimation.pause()
	$ClickAnimation.set_frame()
	print("fuck")
	$ClickAnimation.visible = true

func _on_click_animation_animation_finished():
	$ClickAnimation.visible = false
