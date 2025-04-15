extends Area2D

var interval = 0.002

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Texture.color.a = $Texture.color.a + interval
	if $Texture.color.a > 0.4:
		interval = -0.002
	elif $Texture.color.a < 0.1:
		interval = 0.002

func _on_body_entered(body):
	if body is Player:
		get_node("../../../Selection").setup()
		queue_free()
		get_tree().paused = true
		get_node("../../../Selection").visible = true
