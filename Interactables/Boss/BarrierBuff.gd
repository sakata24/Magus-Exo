class_name BarrierBuff extends Area2D

var interval = 0.008

func _on_timer_timeout() -> void:
	queue_free()

func _process(delta: float) -> void:
	if $Timer.time_left <= 2.0:
		$Sprite2D.modulate.a = $Sprite2D.modulate.a + interval
		if $Sprite2D.modulate.a > 0.4:
			interval = -0.008
		elif $Sprite2D.modulate.a < 0.2:
			interval = 0.008


func _on_area_entered(area: Area2D) -> void:
	if area is PhotonBullet:
		area.look_at(area.spell_caster.global_position)
		area.dmg = 1
		area.set_collision_mask_value(2, true)
		area.set_collision_mask_value(1, false)
