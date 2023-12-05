extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	print("hi")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for body in get_overlapping_bodies():
		if body.is_in_group("monsters") and ((body.health * 10) <= (body.maxHealth) and body.health > 0):
			body._hit(999, Color(255, 255, 255))
