class_name LibrarianNPC extends NPC

var librarianRes = [preload("res://Resources/npc/librarian-0.tres"), preload("res://Resources/npc/librarian-1.tres")]
var Shop = preload("res://HUDs/Shop.tscn")

# librarian is a spell peddler

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tooltip = $Tooltip
	tooltip.change_title("The Librarian:")
	tooltip.change_text("A spell peddler that will teach you new spells for a price.")
	super()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_button_pressed():
	emit_signal("button_pressed", Shop.instantiate())
