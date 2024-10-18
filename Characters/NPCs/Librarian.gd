extends "res://Characters/NPCs/NPC.gd"

var librarianRes = [preload("res://Resources/npc/librarian-0.tres"), preload("res://Resources/npc/librarian-1.tres")]
var index = 0

# librarian is a spell peddler
var shop_data = [
	{
		"name": "abc",
		"desc": "this is a description"
	},
	{
		"name": "lmf",
		"desc": "this is a description"
	}
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Shop/SpriteNode/TextureRect.texture = librarianRes[0]
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
	if index == librarianRes.size():
		index = 0
	$Shop/SpriteNode/TextureRect.texture = librarianRes[index]
	index += 1
