extends Spell


# Called when the node enters the scene tree for the first time.
func _ready():
	dmg = 30
	cooldown = 1.5

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_TimeoutTimer_timeout():
	self.set_collision_mask_value(2, false)
	self.modulate.a = 0.35
	$LifetimeTimer.start()
