extends Area2D

const base_sphere_radius = 64
# Called when the node enters the scene tree for the first time.
func _ready():
	var newPoly = PackedVector2Array()
	var curMax = 0
	for point in get_parent().get_node("CollisionPolygon2D").polygon:
		curMax = max(abs(point.x - self.position.x), abs(point.y - self.position.y))
		newPoly.append(point * 2.5)
	$CollisionShape2D.shape.radius = curMax + 20
	$CPUParticles2D.emission_sphere_radius = curMax + 20
	$CPUParticles2D.scale_amount_min = (curMax)/base_sphere_radius
	$CPUParticles2D.scale_amount_max = (curMax + 20)/base_sphere_radius


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_attack_timer_timeout():
	for body in get_overlapping_bodies():
		if body.is_in_group("monsters"):
			body._hit(5 + floor(get_parent().dmg/6), Color("#ffffff"))
