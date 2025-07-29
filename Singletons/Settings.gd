extends Node

enum {WINDOW_TYPE_WINDOWED, WINDOW_TYPE_FULLSCREEN, WINDOW_TYPE_BORDERLESS}
enum {VOLUME_BUS_MASTER}

var dev_mode = false
var window = 0
var resolution = 0
var master_volume = 100.0
var tooltips_enabled = true

func get_all_data() -> Dictionary: 
	return {
		"window" : window,
		"resolution" : resolution,
		"master_volume" : master_volume,
		"tooltips_enabled": tooltips_enabled
	}

func get_controls_from_event(event_as_string: String) -> String:
	var control_keys = ""
	for event in InputMap.action_get_events(event_as_string):
		control_keys += event.as_text().substr(0, event.as_text().find("("))
		if InputMap.action_get_events(event_as_string).find(event) < InputMap.action_get_events(event_as_string).size() - 1:
			control_keys += "/ "
	return control_keys.strip_edges()

func _ready() -> void:
	fetch_save_data()
	_update_settings()
	add_to_group("Persist")

func _update_settings():
	#set_window_type()
	set_master_volume()

func set_window_type():
	match window:
		WINDOW_TYPE_WINDOWED:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		WINDOW_TYPE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		WINDOW_TYPE_BORDERLESS:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

func set_master_volume():
	AudioServer.set_bus_volume_linear(VOLUME_BUS_MASTER, master_volume/100)

func save():
	return get_all_data()

func fetch_save_data():
	var saved_data: Dictionary = SaveLoader.get_data(name)
	verify_json_data(saved_data)
	
	window = int(saved_data["window"])
	resolution = int(saved_data["resolution"])
	master_volume = float(saved_data["master_volume"])
	tooltips_enabled = bool(saved_data["tooltips_enabled"])

# verifies that all necessary fields are present in the loaded save. if not, fix it
func verify_json_data(json: Dictionary):
	for field in get_script().get_script_property_list():
		if field.name not in json.keys():
			print("key not found for: " + field.name)
			json[field.name] = get(field.name)
