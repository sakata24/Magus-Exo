extends Node2D

@onready var level_handler: LevelHandler = get_parent()

func _ready():
	level_handler.setup_boss_room(self)
	$LuminousEye.connect("boss_dead", Callable(self, "_boss_died"))
	$LuminousEye.player.global_position = $PlayerSpawnPos.global_position
	level_handler.play_song("crystal_mirror")

func _boss_died():
	_cleanup_room()
	_show_exit()

func _cleanup_room():
	for node in get_children():
		if node is not NavigationRegion2D and node is not ExitDoor:
			node.queue_free()

func _show_exit():
	$ExitDoor.visible = true
