extends Node

enum WINDOW_TYPE {WINDOWED, FULLSCREEN, BORDERLESS}
enum RESOLUTION {WINDOWED, FULLSCREEN, BORDERLESS}

var settings_dict = {
	"dev_mode" : true,
	"window" : 0,
	"resolution" : 0,
	"master_volume" : 100
}

func save():
	return settings_dict
