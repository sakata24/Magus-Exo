extends MarginContainer

const ART_PATH = "res://Resources/icons/"

signal selected

var spellData : Dictionary

var equipped = -1

func _ready() -> void:
	$VBoxContainer/MarginContainer/OwnedLabelContainer.visible = false

func set_spell_info(n : String, el : String, desc : String):
	spellData = {
		"name" : n,
		"element" : el,
		"owned" : false,
		"description" : desc
	}
	_set_ui()

func _set_ui():
	$VBoxContainer/SkillName.text = spellData.name
	
	var texture = load(ART_PATH+spellData.name+".png")
	if !texture:
		texture = load("res://Resources/icon.png")
		
	$VBoxContainer/MarginContainer/MarginContainer/MarginContainer/MarginContainer/MarginContainer2/SpellIcon.texture = texture

func set_owned():
	spellData.owned = true
	$VBoxContainer/MarginContainer/OwnedLabelContainer.visible = true
	$VBoxContainer/MarginContainer/MarginContainer/BGColor.light_mask = 0
	$VBoxContainer/MarginContainer/MarginContainer/MarginContainer/MarginContainer2/BGColor.light_mask = 0
	$VBoxContainer/MarginContainer/MarginContainer/MarginContainer/MarginContainer/MarginContainer2/SpellIcon.light_mask = 0

func set_equipped(key : int):
	equipped = key
	var keyBind
	match key:
		0:
			keyBind = "Q"
		1:
			keyBind = "W"
		2:
			keyBind = "E"
		3: 
			keyBind = "R"
	$VBoxContainer/MarginContainer/OwnedLabelContainer/Label.text = keyBind
	$VBoxContainer/MarginContainer/OwnedLabelContainer.visible = true
	$VBoxContainer/MarginContainer/MarginContainer/BGColor.light_mask = 0
	$VBoxContainer/MarginContainer/MarginContainer/MarginContainer/MarginContainer2/BGColor.light_mask = 0
	$VBoxContainer/MarginContainer/MarginContainer/MarginContainer/MarginContainer/MarginContainer2/SpellIcon.light_mask = 0

func set_unequipped():
	equipped = -1
	$VBoxContainer/MarginContainer/OwnedLabelContainer.visible = false
	$VBoxContainer/MarginContainer/MarginContainer/BGColor.light_mask = 2
	$VBoxContainer/MarginContainer/MarginContainer/MarginContainer/MarginContainer2/BGColor.light_mask = 2
	$VBoxContainer/MarginContainer/MarginContainer/MarginContainer/MarginContainer/MarginContainer2/SpellIcon.light_mask = 2

func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("L-Click"):
		if not spellData.owned && (equipped < 0):
			emit_signal("selected", self, $VBoxContainer/MarginContainer/MarginContainer/MarginContainer/MarginContainer/MarginContainer2/SpellIcon.texture)


func _on_mouse_entered() -> void:
	if not spellData.owned && (equipped < 0):
		$VBoxContainer/MarginContainer/BorderOutside.color = Color(1, 0.82, 0.157)


func _on_mouse_exited() -> void:
	$VBoxContainer/MarginContainer/BorderOutside.color = Color.WHITE
