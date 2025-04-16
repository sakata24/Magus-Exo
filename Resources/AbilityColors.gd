class_name AbilityColor extends Node

static var SUNDER = Color("7a0002")
static var ENTROPY = Color("ffd966")
static var GROWTH = Color("36c72c")
static var CONSTRUCT = Color("663c33")
static var FLOW = Color("82b1ff")
static var WITHER = Color("591b82")
static var OTHER = Color("ffffff")

static func get_color_by_string(element: String):
	match element:
		"sunder": return SUNDER
		"entropy": return ENTROPY
		"growth": return GROWTH
		"construct": return CONSTRUCT
		"flow": return FLOW
		"wither": return WITHER
		_: return OTHER
