extends "res://Abilities/Spell.gd"


# Called when the node enters the scene tree for the first time.
func _ready():
	dmg = 25
	cooldown = 1.3
	set_collision_mask_value(2, false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_TimeoutTimer_timeout():
	set_collision_mask_value(2, true)
	$AnimatedSprite2D.animation = "hit"
