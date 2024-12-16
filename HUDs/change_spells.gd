extends CanvasLayer

signal equip_skill(idx, newSkill)

var owned_skills = []
var equipped_skills = []
const ART_PATH = "res://Resources/icons/"
var selected_item = 9999
enum {
	ABILITY1,
	ABILITY2,
	ABILITY3,
	ABILITY4
}

@onready var ability1 = $Control/VBoxContainer/HBoxContainer/EquippedAbilities/Ability1
@onready var ability2 = $Control/VBoxContainer/HBoxContainer/EquippedAbilities/Ability2
@onready var ability3 = $Control/VBoxContainer/HBoxContainer/EquippedAbilities/Ability3
@onready var ability4 = $Control/VBoxContainer/HBoxContainer/EquippedAbilities/Ability4
@onready var owned_list = $Control/VBoxContainer/HBoxContainer/OwnedAbilities/ItemList

func _ready() -> void:
	pass

# initialize the UI
func init(init_owned, init_equipped):
	owned_skills = init_owned
	equipped_skills = init_equipped
	selected_item = 9999
	load_equipped_ability(ability1, "Q: ", equipped_skills[0])
	load_equipped_ability(ability2, "W: ", equipped_skills[1])
	load_equipped_ability(ability3, "E: ", equipped_skills[2])
	load_equipped_ability(ability4, "R: ", equipped_skills[3])
	owned_list.clear()
	for x in owned_skills:
		if !equipped_skills.has(x):
			var iconTexture = load(ART_PATH+x+".png")
			if !iconTexture:
				iconTexture = load("res://Resources/icon.png")
			owned_list.add_item(x, iconTexture)

# sets an ability icon and string when loading menu
func load_equipped_ability(ability_var: MarginContainer, keypress: String, ability_name: String):
	ability_var.get_node("HBoxContainer/SkillMargin/SkillIcon").init(ability_name)
	ability_var.get_node("HBoxContainer/SkillName").set_text(keypress + ability_name)

func update_ui():
	ability1.get_node("Body").color = Color("00000064")
	ability2.get_node("Body").color = Color("00000064")
	ability3.get_node("Body").color = Color("00000064")
	ability4.get_node("Body").color = Color("00000064")
	match selected_item:
		ABILITY1: ability1.get_node("Body").color = Color("44444464")
		ABILITY2: ability2.get_node("Body").color = Color("44444464")
		ABILITY3: ability3.get_node("Body").color = Color("44444464")
		ABILITY4: ability4.get_node("Body").color = Color("44444464")

func _on_ability_1_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			print("I've been clicked D: 1")
			selected_item = ABILITY1
			update_ui()

func _on_ability_2_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			print("I've been clicked D: 2")
			selected_item = ABILITY2
			update_ui()

func _on_ability_3_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			print("I've been clicked D: 3")
			selected_item = ABILITY3
			update_ui()

func _on_ability_4_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			print("I've been clicked D:4 ")
			selected_item = ABILITY4
			update_ui()

func _on_equip_skill_pressed() -> void:
	print(selected_item != 9999)
	print(owned_list.is_anything_selected())
	if(owned_list.is_anything_selected() and (selected_item != 9999)):
		# add the skill to be removed to the owned list
		if !owned_skills.has(equipped_skills[selected_item]):
			owned_skills.append(equipped_skills[selected_item])
		# add the skill to be equipped to replace the one in that slot
		equipped_skills[selected_item] = owned_list.get_item_text(owned_list.get_selected_items()[0])
		emit_signal("equip_skill", selected_item, owned_list.get_item_text(owned_list.get_selected_items()[0]))
		init(owned_skills, equipped_skills)
		update_ui()
