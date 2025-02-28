class_name MonsterIdleState extends State

@export var monster: Monster

func physics_update(delta: float):
	if !monster.can_move:
		Transitioned.emit(self, "Stunned")
		return
	elif monster.aggro:
		Transitioned.emit(self, "Chase")
	monster.set_velocity(Vector2.ZERO)
