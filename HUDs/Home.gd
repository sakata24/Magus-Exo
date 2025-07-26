extends Control

func _ready():
	pass


func _on_StartButton_pressed():
	Lobby.create_game()
	Lobby.load_game.rpc("res://Main.tscn")


func _on_multiplayer_button_pressed() -> void:
	get_tree().change_scene_to_file("res://HUDs/MultiplayerUI.tscn")


func _on_settings_button_pressed() -> void:
	get_tree().change_scene_to_file("res://HUDs/Settings.tscn")
