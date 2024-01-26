extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var newPoly = PackedVector2Array()
	for point in get_parent().get_node("CollisionPolygon2D").polygon:
		newPoly.append(point * 2.5)
	$Polygon2D.polygon = newPoly
	$CollisionPolygon2D.polygon = newPoly


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_attack_timer_timeout():
	for body in get_overlapping_bodies():
		if body.is_in_group("monsters"):
			body._hit(5 + floor(get_parent().dmg/6), Color("#ffffff"))
