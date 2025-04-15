class_name BarrierBuff extends Area2D

var interval = 0.008

func _on_timer_timeout() -> void:
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	print(body)
	if body is PhotonBullet:
		body.look_at(body.spell_caster)
		body.set_collision_mask_value(2, true)
		body.set_collision_mask_value(1, false)

func _process(delta: float) -> void:
	if $Timer.time_left <= 2.0:
		$Sprite2D.modulate.a = $Sprite2D.modulate.a + interval
		if $Sprite2D.modulate.a > 0.4:
			interval = -0.008
		elif $Sprite2D.modulate.a < 0.2:
			interval = 0.008
