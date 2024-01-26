extends CanvasLayer

signal skill_changed(idx, newSkill)

func _ready():
	var skillDict = UniversalSkills.get_skills()
	for skill in skillDict:
		$VBoxContainer2/OptionButton.add_item(skill)
		$VBoxContainer2/OptionButton2.add_item(skill)
		$VBoxContainer2/OptionButton3.add_item(skill)
		$VBoxContainer2/OptionButton4.add_item(skill)

func _on_QuitButton_pressed():
	$QuitConfirm.popup()

func _on_QuitConfirm_confirmed():
	get_tree().quit()

func _on_option_button_item_selected(index):
	emit_signal("skill_changed", 0, $VBoxContainer2/OptionButton.get_item_text(index))

func _on_option_button_2_item_selected(index):
	emit_signal("skill_changed", 1, $VBoxContainer2/OptionButton2.get_item_text(index))

func _on_option_button_3_item_selected(index):
	emit_signal("skill_changed", 2, $VBoxContainer2/OptionButton3.get_item_text(index))

func _on_option_button_4_item_selected(index):
	emit_signal("skill_changed", 3, $VBoxContainer2/OptionButton4.get_item_text(index))
