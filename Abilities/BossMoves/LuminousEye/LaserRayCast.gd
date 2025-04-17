class_name LaserRayCast extends RayCast2D

func _physics_process(delta: float) -> void:
	for child in get_children():
		child.queue_free()
	if is_colliding() and get_collider() is LuminousMirror:
		bounce_on_mirror(get_collider())

func bounce_on_mirror(collider: LuminousMirror):
	# need to ensure collider is still valid after force update
	var new_laser_ray: LaserRayCast = LaserRayCast.new()
	add_child(new_laser_ray)
	new_laser_ray.global_position = self.get_collision_point()
	new_laser_ray.target_position = to_local(self.target_position.bounce(collider.mirror.perpendicular_angle))
	new_laser_ray.set_collision_mask_value(1, false)
	new_laser_ray.set_collision_mask_value(7, true)
	new_laser_ray.collide_with_areas = true
	new_laser_ray.collide_with_bodies = false
	new_laser_ray.add_exception(get_collider())
	new_laser_ray.force_raycast_update()
	if new_laser_ray.is_colliding() and new_laser_ray.get_collider() is LuminousMirror:
		new_laser_ray.bounce_on_mirror(new_laser_ray.get_collider())

func get_reflection_points():
	if get_children().size() >= 1:
		var points = [self.global_position]
		points.append_array(get_child(0).get_reflection_points())
		return points
	else:
		return [self.global_position, to_global(self.target_position)]
