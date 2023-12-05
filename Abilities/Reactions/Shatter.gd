extends Area2D

var parent
var dmg = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.scale = self.scale + Vector2(0.01, 0.01) * parent.scale

func _on_timer_timeout():
	parent.queue_free()

func _on_body_entered(body):
	if body.is_in_group("monsters"):
		body._hit(dmg, parent.get_node("Texture").color)
