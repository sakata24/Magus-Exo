extends CanvasLayer

var SettingMenu = preload("res://HUDs/Settings.tscn")

signal skill_changed(idx, newSkill)

func _ready():
	if Settings.settings_dict["dev_mode"]:
		var skillDict = PersistentData.get_equipped_skills()
		for i in skillDict.size():
			if skillDict[i]:
				var skill = skillDict[i]
				get_node("VBoxContainer2/OptionButton" + str(i+1)).add_icon_item(load("res://Resources/icons/" + skill + ".png"), skill)
	else:
		for optionButton in $VBoxContainer2.get_children():
			optionButton.visible = false
		$Descriptions.visible = false

func _on_QuitButton_pressed():
	$QuitConfirm.popup()

func _on_QuitConfirm_confirmed():
	get_tree().quit()

func _on_settings_button_pressed() -> void:
	get_parent()._add_menu(SettingMenu.instantiate())

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
