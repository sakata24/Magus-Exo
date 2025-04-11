extends Node2D

enum {LEFT, RIGHT}
var getting_in_position = [false, false]

signal both_in_position

func _ready() -> void:
	$StageMaster.sm_init(LEFT, $Marker2D)
	$StageMaster2.sm_init(RIGHT, $Marker2D)
	connect("both_in_position", $StageMaster/StateMachine/Select.begin_selection)
	connect("both_in_position", $StageMaster2/StateMachine/Select.begin_selection)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		await get_tree().create_timer(1).timeout
		$StageMaster.start()
		$StageMaster2.start()

func set_getting_in_position(hand : int):
	getting_in_position[hand] = true
	if getting_in_position[LEFT] && getting_in_position[RIGHT]:
		emit_signal("both_in_position")
		getting_in_position[LEFT] = false
		getting_in_position[RIGHT] = false
