extends CanvasLayer


func _ready():
	pass


func _on_StartButton_pressed():
	GameManager.change_scene_to_file("res://Main.tscn")
