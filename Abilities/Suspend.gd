extends Spell


# Called when the node enters the scene tree for the first time.
func _ready():
	dmg = 1
	$TimeoutTimer.wait_time = 0.13
	$LifetimeTimer.wait_time = 5.0
	cooldown = 0.9

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_TimeoutTimer_timeout():
	self.set_collision_mask_value(2, !get_collision_mask_value(2))
