extends Node

enum {WINDOW_TYPE_WINDOWED, WINDOW_TYPE_FULLSCREEN, WINDOW_TYPE_BORDERLESS}
enum {VOLUME_BUS_MASTER}

var settings_dict = {
	"dev_mode" : true,
	"window" : 0,
	"resolution" : 0,
	"master_volume" : 100.0,
	"tooltips_enabled": true
}

func _ready() -> void:
	_load()
	_update_settings()
	add_to_group("Persist")

func _update_settings():
	set_window_type()
	set_master_volume()

func set_window_type():
	match settings_dict["window"]:
		WINDOW_TYPE_WINDOWED:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		WINDOW_TYPE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		WINDOW_TYPE_BORDERLESS:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

func set_master_volume():
	AudioServer.set_bus_volume_linear(VOLUME_BUS_MASTER, settings_dict["master_volume"]/100)

func save():
	var save_file = FileAccess.open("user://usersettings.save", FileAccess.WRITE)
	
	# JSON provides a static method to serialized JSON string.
	var json_string = JSON.stringify(settings_dict)
	
	# Store the save dictionary as a new line in the save file.
	save_file.store_line(json_string)

func _load():
	if not FileAccess.file_exists("user://usersettings.save"):
		return # Error! We don't have a save to load.
	var save_file = FileAccess.open("user://usersettings.save", FileAccess.READ)
	# read the first line
	var json_string = save_file.get_line()
	var json = JSON.new()

	# Check if there is any error while parsing the JSON string, skip in case of failure
	var parse_result = json.parse(json_string)
	if not parse_result == OK:
		print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
		return
	# Get the data from the JSON object
	var node_data = json.get_data()
	settings_dict["dev_mode"] = bool(node_data["dev_mode"])
	settings_dict["window"] = int(node_data["window"])
	settings_dict["resolution"] = int(node_data["resolution"])
	settings_dict["master_volume"] = float(node_data["master_volume"])
	settings_dict["tooltips_enabled"] = bool(node_data["tooltips_enabled"])
