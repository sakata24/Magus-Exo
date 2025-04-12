class_name PhotonLaser extends Node2D

var current_target
signal attack_finished
@onready var spell_spawn_pos = get_parent().get_node("ProjectilePivot/SpellSpawnPos")

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	$LaserRayCast.position = to_local(get_parent().get_node("ProjectilePivot/SpellSpawnPos").global_position)
	$LaserIndicator.clear_points()
	$LaserIndicator.add_point(to_local(spell_spawn_pos.global_position))
	if $LaserRayCast.is_colliding():
		for point in $LaserRayCast.get_reflection_points():
			$LaserIndicator.add_point(to_local(point))
	elif $LaserRayCast.enabled:
		$LaserIndicator.add_point(current_target)

func charge(target: Vector2):
	current_target = to_local(target) * 10
	$LaserRayCast.target_position = current_target
	$LaserRayCast.enabled = true
	$LaserTimer.start()
	$LaserIndicator.visible = true

func _on_laser_timer_timeout() -> void:
	$LaserIndicator.visible = false
	var laser_points = $LaserIndicator.points.duplicate()
	$LaserIndicator.clear_points()
	var dummy_pos = position
	for point in laser_points:
		var x = dummy_pos.distance_to(point)
		var laser_polygon = CollisionPolygon2D.new()
		laser_polygon.polygon = PackedVector2Array([Vector2(0, -16.0), Vector2(0, 16.0), Vector2(x, 16.0), Vector2(x, -16.0)])
		var damage_area = Area2D.new()
		damage_area.add_child(laser_polygon)
		damage_area.set_collision_layer_value(1, false)
		damage_area.set_collision_mask_value(1, true)
		damage_area.connect("body_entered", _on_body_entered)
		self.add_child(damage_area)
		damage_area.position = dummy_pos
		damage_area.look_at(to_global(point))
		dummy_pos = point
		
		$LaserDamageTexture.add_point(point)
		$AnimationPlayer.play("LaserAttack")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	$LaserDamageTexture.clear_points()
	for child in get_children():
		if child is Area2D:
			child.queue_free()
	$LaserRayCast.enabled = false
	attack_finished.emit()

func _on_body_entered(body: PhysicsBody2D):
	if body is Player:
		var dmg = DamageObject.new()
		dmg.init(15)
		body.hit(dmg)
