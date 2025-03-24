extends MarginContainer

const ART_PATH = "res://Resources/icons/"

signal selected

var spellData : Dictionary

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


func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("L-Click"):
		if not spellData.owned:
			emit_signal("selected", spellData, $VBoxContainer/MarginContainer/MarginContainer/MarginContainer/MarginContainer/MarginContainer2/SpellIcon.texture)


func _on_mouse_entered() -> void:
	if not spellData.owned:
		$VBoxContainer/MarginContainer/BorderOutside.color = Color(1, 0.82, 0.157)


func _on_mouse_exited() -> void:
	$VBoxContainer/MarginContainer/BorderOutside.color = Color.WHITE
