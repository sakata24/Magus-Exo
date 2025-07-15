class_name PlayerIdleState extends State

@export var player: Player
@onready var animation: AnimatedSprite2D = player.get_node("AnimatedSprite2D")

func enter():
	var frame = animation.frame
	animation.set_animation("idle")
	animation.set_frame_and_progress(frame, animation.frame_progress)

func exit():
	pass

func update(delta: float):
	pass

func physics_update(delta: float):
	if player.health <= 0:
		Transitioned.emit(self, "Dead")
	if Input.is_action_just_pressed('R-Click'):
		Transitioned.emit(self, "Moving")
	if Input.is_action_just_pressed('Space'):
		if player.canDash:
			Transitioned.emit(self, "Dashing")
		else:
			var dash_cd_text: PopupText = player.popup_text.instantiate()
			player.add_child(dash_cd_text)
			dash_cd_text.set_value_and_pos("dash not ready!", player.global_position)
	if player.canCast:
		if Input.is_action_just_pressed('Q') and await player.cast_ability(0):
			Transitioned.emit(self, "Casting")
		if Input.is_action_just_pressed('W') and await player.cast_ability(1):
			Transitioned.emit(self, "Casting")
		if Input.is_action_just_pressed('E') and await player.cast_ability(2):
			Transitioned.emit(self, "Casting")
		if Input.is_action_just_pressed('R') and await player.cast_ability(3):
			Transitioned.emit(self, "Casting")
