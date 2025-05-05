class_name ConfirmationPopup extends Popup

signal accepted

func _ready() -> void:
	print(position)
	#size.y = 0

func set_label(text : String):
	$MarginContainer/VBoxContainer/LearnConfirmLabel.text = text
	print(text)
	#size.y = 0


func _on_yes_button_pressed() -> void:
	emit_signal("accepted")
	get_parent().menus.pop_front()
	queue_free()


func _on_no_button_pressed() -> void:
	get_parent().menus.pop_front()
	queue_free()
