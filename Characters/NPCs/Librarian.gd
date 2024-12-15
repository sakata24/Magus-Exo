extends "res://Characters/NPCs/NPC.gd"

var librarianRes = [preload("res://Resources/npc/librarian-0.tres"), preload("res://Resources/npc/librarian-1.tres")]
var index = 0

# librarian is a spell peddler
var shop_data = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Shop/Control/SplitContainer/LVBoxContainer/HBoxContainer/Title.text = "Skill Shop"
	$Shop/Control/SplitContainer/LVBoxContainer/HBoxContainer/SpriteNode/TextureRect.texture = librarianRes[0]
	$Shop.shop_data = self.shop_data
	for x in shop_data:
		$Shop/Control/SplitContainer/LVBoxContainer/ItemList.add_item(x["name"])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_inventory(unlocked_skills):
	self.shop_data = []
	# add items to the shop that are not in unlocked_skills
	for skill in UniversalSkills.get_skills():
		if !unlocked_skills.has(skill):
			shop_data.append(UniversalSkills._get_ability(skill))
	$Shop.shop_data = self.shop_data
	# Remove all items
	$Shop/Control/SplitContainer/LVBoxContainer/ItemList.clear()
	for x in self.shop_data:
		$Shop/Control/SplitContainer/LVBoxContainer/ItemList.add_item(x["name"])

func _on_button_pressed():
	emit_signal("button_pressed", $Shop)
	$SpriteTimer.start()

func _on_timer_timeout() -> void:
	if index == librarianRes.size():
		index = 0
	$Shop/Control/SplitContainer/LVBoxContainer/HBoxContainer/SpriteNode/TextureRect.texture = librarianRes[index]
	index += 1
