extends CanvasLayer

func _ready():
	pass


func _on_QuitButton_pressed():
	$QuitConfirm.popup()

func _on_QuitConfirm_confirmed():
	get_tree().quit()
