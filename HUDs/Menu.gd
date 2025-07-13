extends CanvasLayer

var SettingMenu = preload("res://HUDs/Settings.tscn")

signal skill_changed(idx, newSkill)
signal run_ended

func _ready():
	if Settings.dev_mode:
		var skillDict = PersistentData.get_equipped_skills()
		# Load skills in drop down menu
		for k in PlayerSkills.ALL_SKILLS["skills"]:
			$VBoxContainer2/OptionButton1.add_icon_item(load("res://Resources/icons/" + k + ".png"), k)
			$VBoxContainer2/OptionButton2.add_icon_item(load("res://Resources/icons/" + k + ".png"), k)
			$VBoxContainer2/OptionButton3.add_icon_item(load("res://Resources/icons/" + k + ".png"), k)
			$VBoxContainer2/OptionButton4.add_icon_item(load("res://Resources/icons/" + k + ".png"), k)
		# Show equipped skill
		for i in $VBoxContainer2/OptionButton1.item_count:
			if $VBoxContainer2/OptionButton1.get_item_text(i) == skillDict[0]:
				$VBoxContainer2/OptionButton1.selected = i
			if $VBoxContainer2/OptionButton2.get_item_text(i) == skillDict[1]:
				$VBoxContainer2/OptionButton2.selected = i
			if $VBoxContainer2/OptionButton3.get_item_text(i) == skillDict[2]:
				$VBoxContainer2/OptionButton3.selected = i
			if $VBoxContainer2/OptionButton4.get_item_text(i) == skillDict[3]:
				$VBoxContainer2/OptionButton4.selected = i
	else:
		for optionButton in $VBoxContainer2.get_children():
			optionButton.visible = false
		$Descriptions.visible = false

func _on_QuitButton_pressed():
	$QuitConfirm.popup()

func _on_QuitConfirm_confirmed():
	get_tree().quit()

func _on_end_run_button_pressed() -> void:
	$EndRunConfirm.popup()

func _on_end_run_confirm_confirmed() -> void:
	emit_signal("run_ended")

func _on_settings_button_pressed() -> void:
	get_parent()._add_menu(SettingMenu.instantiate())

func _on_save_button_pressed():
	SaveLoader.save_game()

func _on_option_button_item_selected(index):
	emit_signal("skill_changed", 0, $VBoxContainer2/OptionButton1.get_item_text(index))

func _on_option_button_2_item_selected(index):
	emit_signal("skill_changed", 1, $VBoxContainer2/OptionButton2.get_item_text(index))

func _on_option_button_3_item_selected(index):
	emit_signal("skill_changed", 2, $VBoxContainer2/OptionButton3.get_item_text(index))

func _on_option_button_4_item_selected(index):
	emit_signal("skill_changed", 3, $VBoxContainer2/OptionButton4.get_item_text(index))
