extends Area2D

var parent
const base_sphere_radius = 64
# Called when the node enters the scene tree for the first time.
func _ready():
	var newPoly = PackedVector2Array()
	var curMax = 0
	for point in get_parent().get_node("CollisionPolygon2D").polygon:
		curMax = max(abs(point.x - self.position.x), abs(point.y - self.position.y))
		newPoly.append(point * 2.5)
	$CollisionShape2D.shape.radius = curMax
	$CPUParticles2D.emission_sphere_radius = curMax
	$CPUParticles2D.scale_amount_min = (curMax)/base_sphere_radius
	$CPUParticles2D.scale_amount_max = (curMax)/base_sphere_radius


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_SingularityBody_entered(body):
	if body.is_in_group("monsters"):
		body.global_translate(body.global_position.direction_to(self.global_position) * 3)

func _on_drag_timer_timeout():
	monitoring = !monitoring
