# Class specifically for the purpose of loading game saves, to be stored in loaded_data afterwards

extends Node

var loaded_data = {}

func _ready() -> void:
	load_game()

func save_game():
	var save_file = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for node in save_nodes:
		# Check the node has a save function.
		if !node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue

		# Call the node's save function.
		var node_data = node.call("save")
		print("Saved data for Node: ", node)
		# JSON provides a static method to serialized JSON string.
		var json_string = JSON.stringify(node_data)

		# Store the save dictionary as a new line in the save file.
		save_file.store_line("{\"" + node.name + "\":" + json_string + "}")

func load_game():
	if not FileAccess.file_exists("user://savegame.save"):
		return {} # Error! We don't have a save to load.
	var save_file = FileAccess.open("user://savegame.save", FileAccess.READ)
	# read the first line
	var json_string
	var json
	while save_file.get_position() < save_file.get_length():
		json_string = save_file.get_line()
		json = JSON.new()
		# Check if there is any error while parsing the JSON string, skip in case of failure
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
		else:
			loaded_data.merge(json.data)

	print("Save file successfully loaded.")

func get_data(name: String) -> Dictionary:
	if loaded_data.keys().has(name):
		return loaded_data[name]
	else:
		return {}
