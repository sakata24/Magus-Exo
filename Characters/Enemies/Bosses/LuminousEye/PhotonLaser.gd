class_name PhotonLaser extends Node2D

var current_target

func _ready() -> void:
	$DamageArea.add_exception(get_parent())
	$DamageArea.add_exception(get_parent().get_node("FightTriggerArea"))

func charge(target: Vector2):
	for child in $DamageArea.get_children():
		child.queue_free()
	current_target = to_local(target) * 10
	$LaserTimer.start()
	$LaserIndicator.add_point(Vector2(0, 0))
	$LaserIndicator.add_point(current_target)

func _on_laser_timer_timeout() -> void:
	$LaserIndicator.clear_points()
	$LaserDamageTexture.add_point(Vector2(0, 0))
	$AnimationPlayer.play("LaserAttack")
	$DamageArea.target_position = current_target
	handle_collisions($DamageArea)

func handle_collisions(dmg_area: ShapeCast2D):
	dmg_area.force_shapecast_update()
	if !dmg_area.is_colliding():
		$LaserDamageTexture.add_point(dmg_area.target_position)
	for i in range(0, dmg_area.get_collision_count()):
		var collider = dmg_area.get_collider(i)
		if collider is Player:
			var dmg = DamageObject.new()
			dmg.init(15, [], get_parent())
			collider.hit(dmg)
			$LaserDamageTexture.add_point(dmg_area.target_position)
		elif collider is LuminousMirror:
			$LaserDamageTexture.add_point(to_local(dmg_area.get_collision_point(i)))
			var new_damage_area: ShapeCast2D = ShapeCast2D.new()
			dmg_area.add_child(new_damage_area)
			new_damage_area.shape = CircleShape2D.new()
			new_damage_area.shape.radius = 15.0
			new_damage_area.global_position = dmg_area.get_collision_point(i)
			new_damage_area.target_position = dmg_area.target_position.bounce(collider.mirror.perpendicular_angle)
			handle_collisions(new_damage_area)
		else:
			$LaserDamageTexture.add_point(dmg_area.target_position)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	$LaserDamageTexture.clear_points()
