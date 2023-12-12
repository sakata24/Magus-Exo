extends Area2D

var parent
var dmg = 0
var max_size = Vector2(1.5, 1.5)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print(self.scale)
	print(max_size)
	if self.scale >= max_size:
		print("die mf")
		parent.queue_free()
	self.scale = self.scale + Vector2(0.07, 0.07)
	print(parent.size)

func _on_timer_timeout():
	parent.queue_free()

func _on_body_entered(body):
	if body.is_in_group("monsters"):
		body._hit(dmg, parent.get_node("Texture").color)
