class_name MonsterChaseState extends State

@export var monster: Monster
var chase_target: CharacterBody2D = null
@onready var animation: AnimatedSprite2D = monster.get_node("AnimatedSprite2D")

func enter():
	animation.set_animation("idle")
	animation.play()
	chase_target = monster.player

func update(delta: float):
	if monster.velocity.x < 0:
		animation.flip_h = true
	elif monster.velocity.x > 0:
		animation.flip_h = false

func physics_update(delta: float):
	if !chase_target:
		Transitioned.emit(self, "Idle")
	if !monster.can_move:
		Transitioned.emit(self, "Stunned")
		return
	if monster.global_position.distance_to(chase_target.global_position) <= monster.attack_range:
		Transitioned.emit(self, "Attacking")
		return
	if monster.global_position.distance_to(chase_target.global_position) > monster.attack_range:
		var new_velocity = monster.global_position.direction_to(monster.move_target) * monster.speed
		monster.velocity = new_velocity
		return
