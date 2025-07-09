class_name Tooltip extends Control

func _ready():
	pass

func change_title(new_title: String):
	$ContentMargin/ContentContainer/Title.text = new_title

func change_text(new_text: String):
	$ContentMargin/ContentContainer/Body.text = new_text
