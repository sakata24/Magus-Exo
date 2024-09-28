extends Monster

signal destroyed_crystal

func _ready():
	speed = 0
	baseSpeed = 0

# hit by something
func _hit(dmg_to_take, dmg_color):
	health -= dmg_to_take
	print("i took ", dmg_to_take, " dmg")
	var dmgNum = damageNumber.instantiate()
	dmgNum.modulate = dmg_color
	get_parent().add_child(dmgNum)
	dmgNum.set_value_and_pos(self.global_position, dmg_to_take)


# when i die
func die():
	emit_signal("destroyed_crystal")
	queue_free()
