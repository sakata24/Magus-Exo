extends MarginContainer

func _ready():
	_hide_ability_names()

func _show_ability_names():
	$Body.visible = true
	$HBoxContainer/SkillName.self_modulate = Color(1,1,1,1)

func _hide_ability_names():
	$Body.visible = false
	$HBoxContainer/SkillName.self_modulate = Color(1,1,1,0)
