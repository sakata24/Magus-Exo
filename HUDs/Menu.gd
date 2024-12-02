extends CanvasLayer

signal skill_changed(idx, newSkill)

func _ready():
	if Settings.dev_mode:
		var skillDict = UniversalSkills.get_skills()
		for skill in skillDict:
			if skill:
				$VBoxContainer2/OptionButton.add_icon_item(load("res://Resources/icons/" + skill + ".png"), skill)
				$VBoxContainer2/OptionButton2.add_icon_item(load("res://Resources/icons/" + skill + ".png"), skill)
				$VBoxContainer2/OptionButton3.add_icon_item(load("res://Resources/icons/" + skill + ".png"), skill)
				$VBoxContainer2/OptionButton4.add_icon_item(load("res://Resources/icons/" + skill + ".png"), skill)
	else:
		$VBoxContainer2/OptionButton.visible = false
		$VBoxContainer2/OptionButton2.visible = false
		$VBoxContainer2/OptionButton3.visible = false
		$VBoxContainer2/OptionButton4.visible = false
		$Descriptions.visible = false

func _on_QuitButton_pressed():
	$QuitConfirm.popup()

func _on_QuitConfirm_confirmed():
	get_tree().quit()

func _on_save_button_pressed():
	get_node("/root/CustomResourceLoader").save_game()

func _on_option_button_item_selected(index):
	emit_signal("skill_changed", 0, $VBoxContainer2/OptionButton.get_item_text(index))

func _on_option_button_2_item_selected(index):
	emit_signal("skill_changed", 1, $VBoxContainer2/OptionButton2.get_item_text(index))

func _on_option_button_3_item_selected(index):
	emit_signal("skill_changed", 2, $VBoxContainer2/OptionButton3.get_item_text(index))

func _on_option_button_4_item_selected(index):
	emit_signal("skill_changed", 3, $VBoxContainer2/OptionButton4.get_item_text(index))

func update_exp_count(sunder, entropy, construct, growth, flow, wither):
	$VBoxContainer/HBoxContainer/XPCounts.text = str(sunder) + "\n" + str(entropy) + "\n" + str(construct) + "\n" + str(growth) + "\n" + str(flow) + "\n" + str(wither)
