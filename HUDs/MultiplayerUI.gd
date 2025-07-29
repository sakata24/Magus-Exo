extends Control

@onready var ip_address_entry: LineEdit = $StylizedContainer/ControlMarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/IPEntry
@onready var name_entry: LineEdit = $StylizedContainer/ControlMarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/NameEntry
@onready var player_list_label: Label = $StylizedContainer/ControlMarginContainer/VBoxContainer/HBoxContainer/VBoxContainer2/PlayerList
@onready var host_button: Button = $StylizedContainer/ControlMarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/HostButton
@onready var join_button: Button = $StylizedContainer/ControlMarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/JoinButton
@onready var start_game_button: Button = $StylizedContainer/ControlMarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/StartGameButton

func _ready() -> void:
	Lobby.connect("player_connected", update_player_list)
	update_player_list("", "")

func update_player_list(peer_id, player_info):
	player_list_label.text = ""
	var list_str: String = ""
	for id in Lobby.players:
		list_str = list_str + str(Lobby.players[id]["name"]) + "\n"
	player_list_label.text = list_str

func _on_name_entry_text_changed(new_text: String) -> void:
	Lobby.player_info["name"] = new_text

func _on_join_button_pressed() -> void:
	Lobby.join_game(ip_address_entry.text)
	host_button.disabled = true
	start_game_button.disabled = true

func _on_host_button_pressed() -> void:
	Lobby.create_game()
	join_button.disabled = true

func _on_start_game_button_pressed() -> void:
	Lobby.load_game.rpc("res://Main.tscn")
