extends MarginContainer

const ART_PATH = "res://Resources/icons/"

signal selected

var spellName : String
var spellElement : String
var spellOwned := false
var spellDescription : String

func _ready() -> void:
	$VBoxContainer/MarginContainer/OwnedLabelContainer.visible = false

func set_spell_info(n : String, el : String, desc : String):
	spellName = n
	spellElement = el
	spellDescription = desc
	_set_ui()

func _set_ui():
	$VBoxContainer/SkillName.text = spellName
	
	var texture = load(ART_PATH+spellName+".png")
	if !texture:
		texture = load("res://Resources/icon.png")
		
	$VBoxContainer/MarginContainer/MarginContainer/MarginContainer/MarginContainer/MarginContainer2/SpellIcon.texture = texture

func set_owned():
	spellOwned = true
	$VBoxContainer/MarginContainer/OwnedLabelContainer.visible = true


func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("L-Click"):
		if not spellOwned:
			emit_signal("selected", spellDescription, $VBoxContainer/MarginContainer/MarginContainer/MarginContainer/MarginContainer/MarginContainer2/SpellIcon.texture)
