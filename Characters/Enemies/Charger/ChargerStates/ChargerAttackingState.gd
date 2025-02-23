class_name ChargerAttackingState extends MonsterAttackingState

func enter():
	monster.attacking = true
	# target PAST the player
	monster.lock_target = monster.player.global_position - ((monster.global_position - monster.player.global_position).normalized()) * 1000
	if monster.global_position.x - monster.lock_target.x > 0:
		monster.get_node("Sprite2D").flip_h = true
	else:
		monster.get_node("Sprite2D").flip_h = false
	super()

func on_attack_timer_timeout():
	Transitioned.emit(self, "Dashing")
