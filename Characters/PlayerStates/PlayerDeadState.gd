class_name PlayerDeadState extends State

@export var player: Player
@onready var animation: AnimatedSprite2D = player.get_node("AnimatedSprite2D")

func enter():
	# disable own collision
	player.set_collision_layer_value(1, false)
	player.set_collision_layer_value(4, false)
	# stop moving
	player.move_target = player.global_position
	animation.set_animation("death")

func _on_death_animation_finished():
	if animation.animation == "death":
		player.emit_signal("player_died")
