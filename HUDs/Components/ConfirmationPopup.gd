class_name ConfirmationPopup extends Popup

signal accepted
signal close_menu

func _ready() -> void:
	connect("close_menu", MenuHandler._close_top_menu)
	print(position)
	#size.y = 0

func set_label(text : String):
	$MarginContainer/VBoxContainer/LearnConfirmLabel.text = text
	print(text)
	#size.y = 0


func _on_yes_button_pressed() -> void:
	emit_signal("accepted")
	close_menu.emit()
	queue_free()


func _on_no_button_pressed() -> void:
	close_menu.emit()
	queue_free()
