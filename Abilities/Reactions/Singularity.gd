extends Area2D

var parent

# Called when the node enters the scene tree for the first time.
func _ready():
	print("instantiated")
	$CollisionPolygon2D.polygon = get_parent().get_node("CollisionPolygon2D").polygon
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_SingularityBody_entered(body):
	print(body.name)
	if body.is_in_group("monsters"):
		body.global_translate(body.global_position.direction_to(self.global_position) * 3)

func _on_drag_timer_timeout():
	print("flip")
	monitoring = !monitoring
