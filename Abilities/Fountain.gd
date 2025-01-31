extends Spell


# Called when the node enters the scene tree for the first time.
func _ready():
	dmg = 25
	cooldown = 1.3
	set_collision_mask_value(2, false)

func _on_timeout_timer_timeout() -> void:
	set_collision_mask_value(2, true)
	$AnimatedSprite2D.animation = "hit"
