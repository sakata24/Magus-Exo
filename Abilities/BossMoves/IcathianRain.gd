extends Bullet

var player : Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	speed = 50
	dmg = 1
	timeout = 1
	lifetime = 6
	size = 1
	scale *= size

func set_player(p : Player, origin : Vector2, rotate : float):
	player = p
	global_position = origin
	rotation = rotate
	$LifetimeTimer.wait_time = lifetime
	# start timer
	$TimeoutTimer.wait_time = timeout

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var collision = move_and_collide(get_velocity().normalized() * delta * speed)
	# check collisions
	if collision:
		if collision.get_collider() is Player:
			collision.get_collider().hit(dmg)
			_delete()

func _turn():
	var tween = create_tween()
	#Can't figure out how to tween look at so yeah
	look_at(player.global_position)
	tween.tween_property(self, "speed", 200, 1).set_ease(Tween.EASE_IN)
	tween.parallel().tween_property(self, "velocity", (player.global_position-position).normalized(), 1)
	$Line2D.started = true


func _on_turn_timer_timeout() -> void:
	_turn()
