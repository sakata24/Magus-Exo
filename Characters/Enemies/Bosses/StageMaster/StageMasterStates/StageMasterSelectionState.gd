extends State

enum {ROCK, PAPER, SCISSORS, GUN, LASER}

@export var STAGE_MASTER : StageMaster
var selection
var new_velocity

func enter():
	STAGE_MASTER.invincible = true
	get_into_position()

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name.contains("build_up"):
		# Show the selected hand
		match selection:
			ROCK:
				STAGE_MASTER.get_node("AnimationPlayer").play("rock")
			PAPER:
				STAGE_MASTER.get_node("AnimationPlayer").play("paper")
			SCISSORS:
				STAGE_MASTER.get_node("AnimationPlayer").play("scissors")
			GUN:
				STAGE_MASTER.get_node("AnimationPlayer").play("gun")
			LASER:
				STAGE_MASTER.get_node("AnimationPlayer").play("lazer")
	await get_tree().create_timer(2).timeout
		# Transition to next state
	match selection:
		ROCK:
			Transitioned.emit(self, "Rock")
		PAPER:
			Transitioned.emit(self, "Paper")
		SCISSORS:
			Transitioned.emit(self, "Scissors")
		GUN:
			Transitioned.emit(self, "Gun")
		LASER:
			Transitioned.emit(self, "Laser")

func get_into_position():
	STAGE_MASTER.getting_into_position = true
	if STAGE_MASTER.which_hand == STAGE_MASTER.LEFT:
		STAGE_MASTER.get_node("NavigationAgent2D").set_target_position(STAGE_MASTER.center_marker.global_position - Vector2(50.0, 0.0))
	else:
		STAGE_MASTER.get_node("NavigationAgent2D").set_target_position(STAGE_MASTER.center_marker.global_position + Vector2(50.0, 0.0))

func begin_selection():
	if STAGE_MASTER.which_hand == STAGE_MASTER.LEFT:
		STAGE_MASTER.flip(true)
		STAGE_MASTER.get_node("AnimationPlayer").play("build_up_right")
	else:
		STAGE_MASTER.flip(false)
		STAGE_MASTER.get_node("AnimationPlayer").play("build_up")
	match STAGE_MASTER.stage:
		2:
			if STAGE_MASTER.which_hand == STAGE_MASTER.LEFT:
				selection = GUN
			else:
				selection = randi_range(ROCK, SCISSORS)
		3:
			if STAGE_MASTER.which_hand == STAGE_MASTER.LEFT:
				selection = GUN
			else:
				selection = LASER
		_:
			#selection = randi_range(ROCK, SCISSORS)
			selection = ROCK

func physics_update(delta):
	new_velocity = STAGE_MASTER.global_position.direction_to(STAGE_MASTER.move_target) * STAGE_MASTER.speed
	STAGE_MASTER.velocity = new_velocity

func exit():
	STAGE_MASTER.invincible = false
