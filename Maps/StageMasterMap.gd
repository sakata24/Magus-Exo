extends Node2D

enum {LEFT, RIGHT}
var getting_in_position = [false, false]
var selected = [false, false]

signal both_in_position
signal select_again
signal selection_accepted

func _ready() -> void:
	$StageMaster.sm_init(LEFT, $Marker2D)
	$StageMaster2.sm_init(RIGHT, $Marker2D)
	connect("both_in_position", $StageMaster/StateMachine/Select.begin_selection)
	connect("both_in_position", $StageMaster2/StateMachine/Select.begin_selection)
	connect("select_again", $StageMaster/StateMachine/Select.begin_selection)
	connect("select_again", $StageMaster2/StateMachine/Select.begin_selection)
	connect("selection_accepted", $StageMaster/StateMachine/Select.transition)
	connect("selection_accepted", $StageMaster2/StateMachine/Select.transition)


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

func check_selection(hand : int):
	selected[hand] = true
	if selected[LEFT] && selected[RIGHT]:
		print("Selection: " + str($StageMaster/StateMachine/Select.selection) + "-" + str($StageMaster2/StateMachine/Select.selection))
		if $StageMaster/StateMachine/Select.selection == $StageMaster2/StateMachine/Select.selection:
			emit_signal("select_again")
		else:
			emit_signal("selection_accepted")
		selected[LEFT] = false
		selected[RIGHT] = false
