# Not a "Menu"
# Usage as follows:
# either use as a flexible menu through "display_text" and "hide_dialogue_hud" to constantly change text
# or employ the use of the "continue_func" in conjunction with the "continue_args" variable to be called when the continue option is selected.

class_name DialogueHUD extends CanvasLayer

@onready var dialogue_label = $MarginContainer/VBoxContainer/StylizedContainer/MarginContainer2/HBoxContainer/VBoxContainer/DisplayText
@onready var directions_label = $MarginContainer/VBoxContainer/StylizedContainer/MarginContainer2/HBoxContainer/VBoxContainer/DirectionsText
@onready var continue_button = $MarginContainer/VBoxContainer/StylizedContainer/MarginContainer2/HBoxContainer/VBoxContainer/ContinueButton

var tween: Tween
var continue_args: Array
var continue_func: Callable

func _ready() -> void:
	self.connect("request_menu", MenuHandler._add_menu)

func display_text(dialogue_to_display: String, directions_to_display: String, time_to_display: float, dim_screen: bool, show_button: bool):
	dialogue_label.text = ""
	directions_label.text = ""
	dialogue_label.text = dialogue_to_display
	dialogue_label.visible_ratio = 0
	if dim_screen:
		$ColorRect.visible = true
	if show_button:
		continue_button.visible = true
	tween = create_tween()
	tween.tween_property(dialogue_label, "visible_ratio", 1.0, time_to_display)
	tween.tween_callback(func():
		directions_label.text = directions_to_display
		directions_label.visible = true
		)
	self.visible = true
	tween.play()

func hide_dialogue_hud():
	tween.kill()
	dialogue_label.text = ""
	dialogue_label.visible_ratio = 0
	directions_label.text = ""
	directions_label.visible = false
	self.visible = false
	$ColorRect.visible = false

func _on_continue_button_pressed() -> void:
	hide_dialogue_hud()
	queue_free()
	if continue_func:
		continue_func.callv(continue_args)
