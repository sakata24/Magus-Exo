extends CanvasLayer

@onready var ConfirmPopup = preload("res://HUDs/Components/ConfirmationPopup.tscn")
# Enum of each setting from how it shows top to bottom
enum SETTING_LIST {RESOLUTION, MASTER_VOL, TOOLTIPS_ENABLED}

# Array of dictionaries to hold:
	# If the setting is changed
	# Reference to the HBoxContainer holding each setting
var settingListArray : Array

func _ready() -> void:
	# Initialize each setting with the node container as well as if it is changed
	settingListArray.append({"changed_value" : null, "node" : $ContentContainer/VBoxContainer/MarginContainer/ScrollContainer/SettingTypeContainer/VideoOptionsMarginContainer/VBoxContainer/Resolution})
	settingListArray.append({"changed_value" : null, "node" : $ContentContainer/VBoxContainer/MarginContainer/ScrollContainer/SettingTypeContainer/AudioOptionsMarginContainer2/VBoxContainer/MasterVolume})
	settingListArray.append({"changed_value" : null, "node" : $ContentContainer/VBoxContainer/MarginContainer/ScrollContainer/SettingTypeContainer/GameOptionsMarginContainer/VBoxContainer/Tooltips})
	# Initialize the values of the UI to match the saved data
	settingListArray[SETTING_LIST.RESOLUTION]["node"].get_node("OptionButton").selected = Settings.resolution
	settingListArray[SETTING_LIST.MASTER_VOL]["node"].get_node("HSlider").value = Settings.master_volume
	settingListArray[SETTING_LIST.TOOLTIPS_ENABLED]["node"].get_node("CheckBox").button_pressed = Settings.tooltips_enabled

func _on_apply_button_pressed() -> void:
	var inst: ConfirmationPopup = ConfirmPopup.instantiate()
	# Set the text
	var button_signals = inst.init(2, "Apply Settings?")
	inst.buttons[0].text = "Yes"
	inst.buttons[1].text = "No"
	button_signals[0].connect(_setting_changes_accepted)
	# Show the confirmation popup
	if get_parent() is Node2D:
		get_parent().add_child(inst)


func _setting_changes_accepted():
	# RESOLUTION
	if settingListArray[SETTING_LIST.RESOLUTION]["changed_value"] != null:
		# Record the change in global settings
		Settings.resolution = settingListArray[SETTING_LIST.RESOLUTION]["changed_value"]
	# MASTER VOLUME
	if settingListArray[SETTING_LIST.MASTER_VOL]["changed_value"] != null:
		# Record the change in global settings
		Settings.master_volume = settingListArray[SETTING_LIST.MASTER_VOL]["changed_value"]
		# Apply the change
		Settings.set_master_volume()
	if settingListArray[SETTING_LIST.TOOLTIPS_ENABLED]["changed_value"] != null:
		# Record the change in global settings
		Settings.tooltips_enabled = settingListArray[SETTING_LIST.TOOLTIPS_ENABLED]["changed_value"]
	
	# Save data
	Settings.save()
	
	# Close settings menu
	MenuHandler._close_top_menu()

# Update the volume amount label
func _on_h_slider_value_changed(value: float) -> void:
	settingListArray[SETTING_LIST.MASTER_VOL]["node"].get_node("Value").text = str(int(value))

# Get the changed value for resolution
func _on_resolution_option_button_item_selected(index: int) -> void:
	settingListArray[SETTING_LIST.RESOLUTION].set("changed_value", index)

func _on_tooltips_enabled_check_box_toggled(toggled_on: bool) -> void:
	settingListArray[SETTING_LIST.TOOLTIPS_ENABLED].set("changed_value", toggled_on)

# Get the changed value for master volume
func _on_h_slider_drag_ended(value_changed: bool) -> void:
	var val = $ContentContainer/VBoxContainer/MarginContainer/ScrollContainer/SettingTypeContainer/AudioOptionsMarginContainer2/VBoxContainer/MasterVolume/HSlider.value
	if value_changed:
		settingListArray[SETTING_LIST.MASTER_VOL].set("changed_value", val)


func _on_cancel_button_pressed() -> void:
	MenuHandler._close_top_menu()
