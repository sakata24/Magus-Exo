extends Node2D

var dmg
# Called when the node enters the scene tree for the first time.
func _ready():
	self.scale = self.scale/get_parent().scale

func init(sunderParent, entropyParent):
	dmg = sunderParent.dmg + entropyParent.dmg
	for n in range(1, 9):
		get_node(str("Projectile", n)).init(450, dmg, self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_timer_timeout():
	queue_free()
