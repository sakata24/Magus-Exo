class_name ConfirmationPopup extends Popup

signal closing

var num_buttons: int
var buttons: Array[Button]

func init(init_num_buttons: int = 0, text: String = "") -> Array[Signal]:
	set_label(text)
	var button_signals: Array[Signal]
	num_buttons = init_num_buttons
	for i in range(init_num_buttons):
		var new_button: Button = Button.new()
		new_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		$MarginContainer/VBoxContainer/HBoxContainer.add_child(new_button)
		button_signals.append(new_button.pressed)
		buttons.append(new_button)
		new_button.connect("pressed", close_menu)
	return button_signals

func _ready() -> void:
	connect("closing", MenuHandler._close_top_menu)
	print(position)
	#size.y = 0

func set_label(text : String):
	$MarginContainer/VBoxContainer/LearnConfirmLabel.text = text
	print(text)
	#size.y = 0

func close_menu():
	emit_signal("closing")
