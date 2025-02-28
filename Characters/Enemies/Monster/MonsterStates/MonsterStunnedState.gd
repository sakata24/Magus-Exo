class_name MonsterStunnedState extends State

@export var monster: Monster

func physics_update(delta):
	if !monster.can_move:
		return
	elif monster.aggro:
		Transitioned.emit(self, "Chase")
	else:
		Transitioned.emit(self, "Idle")
