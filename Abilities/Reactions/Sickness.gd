extends Area2D

var debuffedEnemies

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_tick_timer_timeout():
	$Polygon2D.modulate.a = 0.5
	if has_overlapping_bodies():
		debuffedEnemies = get_overlapping_bodies()
		for body in debuffedEnemies:
			if body.is_in_group("monsters"):
				var rand = randi_range(0, 2)
				if rand == 0:
					body.canMove = false
				elif rand == 1:
					body.speed *= 0.5
				elif rand == 2:
					body.myDmg *= 0.5
		$DebuffTimer.start()

func _on_debuff_timer_timeout():
	for body in debuffedEnemies:
		if body != null and body.is_in_group("monsters"):
			print(body.speed)
			body.canMove = true
			body.speed = body.baseSpeed
			body.myDmg = body.baseDmg


func _on_lifetime_timer_timeout():
	for body in debuffedEnemies:
		if body != null and body.is_in_group("monsters"):
			print(body.speed)
			body.canMove = true
			body.speed = body.baseSpeed
			body.myDmg = body.baseDmg
	queue_free()
