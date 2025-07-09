class_name ArmorerNPC extends NPC

var armorerRes = [preload("res://Resources/npc/armorer-0.tres"), preload("res://Resources/npc/armorer-1.tres")]
var index = 0

var shop_data = [
	{
		"name": "abc",
		"desc": "this is a description",
		"cost": 10
	},
	{
		"name": "lmf",
		"desc": "this is a description",
		"cost": 10
	}
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_button_pressed():
	pass

func _on_timer_timeout() -> void:
	pass
