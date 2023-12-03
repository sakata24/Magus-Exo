extends Area2D

var parent

# Called when the node enters the scene tree for the first time.
func _ready():
	print("instantiated")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	monitoring = parent.monitoring

func _on_SingularityBody_entered(body):
	print(body.name)
	if body.is_in_group("monsters"):
		body.global_translate(body.global_position.direction_to(self.global_position) * (parent.dmg * 0.5) * 3)
		#self.monitoring = false
