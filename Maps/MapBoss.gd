extends Node2D

@export var SPAWN_ENEMIES : bool
@export var MAX_ENEMIES : int = 8

@onready var Mon = preload("res://Characters/Enemies/Monster/Monster.tscn")

var player: Player

func _ready() -> void:
	$Path2D/MoveTimer/SpawnTimer.wait_time = randf_range(2, 6)
	$Path2D/MoveTimer/SpawnTimer.start()
	player = get_tree().get_nodes_in_group("players")[0]
	player.global_position = $PlayerSpawnLoc.global_position
	player.move_target = player.global_position
	$DarkMage.connect("boss_dead", Callable(self, "_boss_died"))

func _process(delta: float) -> void:
	$Path2D/PathFollow2D.progress_ratio = $Path2D/MoveTimer.time_left/$Path2D/MoveTimer.wait_time
	$Path2D/PathFollow2D2.progress_ratio = ($Path2D/MoveTimer.wait_time-$Path2D/MoveTimer.time_left)/$Path2D/MoveTimer.wait_time

func _on_spawn_timer_timeout() -> void:
	if SPAWN_ENEMIES and get_tree().get_nodes_in_group("monsters").size() < MAX_ENEMIES:
		var inst = Mon.instantiate()
		inst.global_position = $Path2D/PathFollow2D.global_position
		add_child(inst)
		inst._on_AggroRange_body_entered(player)
		inst.add_to_group("monsters")
		#Second Spawn
		var inst2 = Mon.instantiate()
		inst2.global_position = $Path2D/PathFollow2D2.global_position
		add_child(inst2)
		inst2._on_AggroRange_body_entered(player)
		inst2.add_to_group("monsters")
		$Path2D/MoveTimer/SpawnTimer.wait_time = randf_range(2, 6)
		$Path2D/MoveTimer/SpawnTimer.start()

func _boss_died():
	$Path2D/MoveTimer/SpawnTimer.stop()
	show_exit()

func show_exit():
	$ExitDoor.visible = true
