extends Area2D

var myParent
var dmg = 0
var max_size = Vector2(1.5, 1.5)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if self.scale >= max_size:
		myParent.queue_free()
	self.scale = self.scale + Vector2(0.01, 0.01)

func _on_timer_timeout():
	myParent.queue_free()

func _on_body_entered(body):
	print(body)
	if body.is_in_group("monsters"):
		body._hit(dmg, myParent.get_node("Texture").color)
