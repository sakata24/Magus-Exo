extends Node2D

func _ready():
	get_parent().setup_boss_room(self)
	$LuminousEye.connect("boss_dead", Callable(self, "_boss_died"))
	$LuminousEye.player.global_position = $PlayerSpawnPos.global_position

func _boss_died():
	_cleanup_room()
	_show_exit()

func _cleanup_room():
	for node in get_children():
		if node is not NavigationRegion2D and node is not ExitDoor:
			node.queue_free()

func _show_exit():
	$ExitDoor.visible = true
