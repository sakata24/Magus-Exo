extends Bullet

@onready var Rain = preload("res://Abilities/BossMoves/IcathianRain.tscn")

var player : Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	speed = 50
	dmg = 50
	timeout = 1
	lifetime = 10
	$LifetimeTimer.wait_time = lifetime
	size = 4
	scale *= size
	$LifetimeTimer.start()

func set_player(p : Player, pos : Vector2):
	player = p
	global_position = pos
	look_at(player.global_position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var collision = move_and_collide(get_velocity().normalized() * delta * speed)
	# check collisions
	if collision:
		if collision.get_collider().is_in_group("skills"):
			set_collision_layer_value(3, false)
			set_collision_mask_value(3, false)
			react()
		elif collision.get_collider() is Player:
			collision.get_collider().hit(dmg)
			_delete()


func react():
	print("MAKE IT RAIN")
	for i in 9:
		var spike = Rain.instantiate()
		var rad = deg_to_rad(360/9 * i)
		var pos = Vector2(0,0)
		pos.x = global_position.x + cos(rad)
		pos.y = global_position.y + sin(rad)
		spike.set_player(player, global_position, rad)
		get_parent().get_parent().add_child(spike)
		spike.add_to_group("enemy_skills")
		spike.add_to_group("skills")
		spike.velocity = (pos - global_position).normalized()
	_delete()
	pass


func _on_LifetimeTimer_timeout():
	queue_free()
