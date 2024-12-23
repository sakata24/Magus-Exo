extends CanvasLayer

signal opened(me)
signal purchased(name)

const ICON_PATH = "res://Resources/icons/"

var shop_data = null
var selected_item = ""
var selected_currency = ""
var selected_price = 0
var selected_idx = null
var player_currencies = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_item_list_item_selected(index: int) -> void:
	# make the buy button visible
	$Control/SplitContainer/VBoxContainer/BuyButton.visible = true
	$Control/SplitContainer/VBoxContainer/BuyButton.disabled = false
	$Control/SplitContainer/VBoxContainer/TextureRect/PurchasedLabel.visible = false
	$Control/SplitContainer/VBoxContainer/TextureRect.self_modulate = Color.WHITE
	# make sure shop has data
	if shop_data:
		# choose item for if purchased
		selected_item = shop_data[index]["name"]
		selected_currency = shop_data[index]["currency"]
		selected_price = shop_data[index]["price"]
		selected_idx = index
		# load the icon
		$Control/SplitContainer/VBoxContainer/TextureRect.texture = load(ICON_PATH+shop_data[index]["name"]+".png")
		if !$Control/SplitContainer/VBoxContainer/TextureRect.texture:
			$Control/SplitContainer/VBoxContainer/TextureRect.texture = load("res://Resources/icon.png")
		# load description
		$Control/SplitContainer/VBoxContainer/Description.text = shop_data[index]["description"]
		$Control/SplitContainer/VBoxContainer/Price.text = "Cost: " + str(shop_data[index]["price"]) + " " + shop_data[index]["currency"]
		# load player currency
		$Control/SplitContainer/VBoxContainer/OwnedCurrency.text = "Owned: " + str(player_currencies[shop_data[index]["currency"]]) + " " + shop_data[index]["currency"]

func _on_buy_button_pressed() -> void:
	# emit signal that gives the player the spell
	emit_signal("purchased", selected_item, selected_currency, selected_price)

func remove_item(name):
	$Control/SplitContainer/LVBoxContainer/ItemList.remove_item(selected_idx)
	$Control/SplitContainer/VBoxContainer/BuyButton.disabled = true
	$Control/SplitContainer/VBoxContainer/TextureRect/PurchasedLabel.visible = true
	$Control/SplitContainer/VBoxContainer/TextureRect.self_modulate = Color.DIM_GRAY
