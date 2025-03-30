extends MarginContainer

const ART_PATH = "res://Resources/icons/"

signal selected

var isSelected := false
var keyBind := -1

func _ready() -> void:
	pass

func set_ui(spellName : String):
	var texture = load(ART_PATH+spellName+".png")
	if !texture:
		texture = load("res://Resources/icon.png")
		
	$VBoxContainer/MarginContainer/MarginContainer/MarginContainer/MarginContainer/MarginContainer2/SpellIcon.texture = texture

func set_key(key : int):
	keyBind = key
	match keyBind:
		0:
			$VBoxContainer/MarginContainer/OwnedLabelContainer/Label.text = "Q"
		1:
			$VBoxContainer/MarginContainer/OwnedLabelContainer/Label.text = "W"
		2:
			$VBoxContainer/MarginContainer/OwnedLabelContainer/Label.text = "E"
		3: 
			$VBoxContainer/MarginContainer/OwnedLabelContainer/Label.text = "R"

func get_key():
	return keyBind

func deselect():
	$VBoxContainer/MarginContainer/BorderOutside.color = Color.WHITE
	isSelected = false

func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("L-Click"):
		$VBoxContainer/MarginContainer/BorderOutside.color = Color(1, 0.82, 0.157)
		isSelected = true
		emit_signal("selected", keyBind)


func _on_mouse_entered() -> void:
	if not isSelected:
		$VBoxContainer/MarginContainer/BorderOutside.color = Color(1, 0.82, 0.157)


func _on_mouse_exited() -> void:
	if not isSelected:
		$VBoxContainer/MarginContainer/BorderOutside.color = Color.WHITE
