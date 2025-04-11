extends State

@onready var SHOCKWAVE_ATTACK = preload("res://Abilities/BossMoves/StageMaster/Shockwave.tscn")

@export var STAGE_MASTER : Boss
@export var ATTACK_COOLDOWN : float = 2.0
@export var RESET_DURATION : float = 5.0

var attack_timer : Timer
var reset_timer : Timer

func enter():
	# Create attack timer
	attack_timer = Timer.new()
	attack_timer.autostart = false
	attack_timer.one_shot = true
	attack_timer.wait_time = ATTACK_COOLDOWN
	attack_timer.connect("timeout", _on_attack_timer_timeout)
	add_child(attack_timer)
	# Create reset timer
	reset_timer = Timer.new()
	reset_timer.autostart = false
	reset_timer.one_shot = true
	reset_timer.wait_time = RESET_DURATION
	reset_timer.connect("timeout", _on_reset_timer_timeout)
	add_child(reset_timer)
	# Start the attack
	attack_timer.start()
	STAGE_MASTER.get_node("AnimationPlayer").play("rock")
	

func _on_attack_timer_timeout():
	if STAGE_MASTER.which_hand == STAGE_MASTER.LEFT:
		STAGE_MASTER.get_node("AnimationPlayer").play("rock_smash_right")
	else:
		STAGE_MASTER.get_node("AnimationPlayer").play("rock_smash")

func _on_reset_timer_timeout():
	STAGE_MASTER.get_node("AnimationPlayer").play("rock")
	STAGE_MASTER.invincible = true
	attack_timer.start()

func exit():
	attack_timer.queue_free()
	reset_timer.queue_free()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name.contains("rock_smash"):
		var inst = SHOCKWAVE_ATTACK.instantiate()
		STAGE_MASTER.add_child(inst)
		STAGE_MASTER.invincible = false
		reset_timer.start()
