extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_value_and_pos(pos, dmg):
	print("hi")
	self.global_position = pos
	$DmgText.text = str(dmg)

func _on_timer_timeout():
	print("hi")
	self.queue_free()
