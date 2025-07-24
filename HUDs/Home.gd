extends CanvasLayer


func _ready():
	pass


func _on_StartButton_pressed():
	Lobby.create_game()
	Lobby.load_game.rpc("res://Main.tscn")
