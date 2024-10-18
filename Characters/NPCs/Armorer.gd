extends "res://Characters/NPCs/NPC.gd"

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
	$Shop/SpriteNode/TextureRect.texture = armorerRes[0]
	$Shop.shop_data = self.shop_data
	for x in shop_data:
		$Shop/Control/SplitContainer/ItemList.add_item(x["name"])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_button_pressed():
	emit_signal("button_pressed", $Shop)
	$SpriteTimer.start()

func _on_timer_timeout() -> void:
	if index == armorerRes.size():
		index = 0
	$Shop/SpriteNode/TextureRect.texture = armorerRes[index]
	index += 1
