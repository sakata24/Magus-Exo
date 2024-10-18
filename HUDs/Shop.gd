extends CanvasLayer

signal opened(me)

var shop_data = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_item_list_item_selected(index: int) -> void:
	if shop_data:
		$Control/SplitContainer/VBoxContainer/Label.text = shop_data[index]["desc"]
