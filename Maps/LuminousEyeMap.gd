extends Node2D

func _ready():
	get_parent().setup_boss_room(self)
	$LuminousEye.connect("boss_dead", Callable(self, "_boss_died"))

func _boss_died():
	show_exit()

func show_exit():
	$ExitDoor.visible = true
