@tool
class_name StylizedContainer extends MarginContainer

@export var container_color: Color = Color("975d38"):
	set(new_color):
		container_color = new_color
		$MarginContainer/BGColor.set_color(container_color)
		$MarginContainer/MarginContainer/MarginContainer/BGColor.color = container_color
		
@export var border_color: Color = Color(1, 1, 1, 1):
	set(new_color):
		border_color = new_color
		# set the borders
		$BorderOutside.color = border_color
		$MarginContainer/MarginContainer/BorderInside.color = border_color
		# modulate the custom corner borders
		$MarginContainer/MarginContainer/HBoxContainer/VBoxContainer2/TextureRect.modulate = border_color
		$MarginContainer/MarginContainer/HBoxContainer/VBoxContainer2/TextureRect2.modulate = border_color
		$MarginContainer/MarginContainer/HBoxContainer/VBoxContainer/TextureRect.modulate = border_color
		$MarginContainer/MarginContainer/HBoxContainer/VBoxContainer/TextureRect2.modulate = border_color
