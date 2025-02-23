extends BaseTypeAbility

var player : Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	speed = 50
	dmg = 1
	timeout = 1
	lifetime = 6
	scale *= 1
	$LifetimeTimer.wait_time = lifetime
	$LifetimeTimer.start()

func set_player(p : Player, origin : Vector2, rotate : float):
	player = p
	global_position = origin
	rotation = rotate

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	handle_movement(delta)

func _turn():
	var tween = create_tween()
	tween.tween_property(self, "rotation", position.angle_to_point(player.global_position), 0.5)
	#Can't figure out how to tween look at so yeah
	#look_at(player.global_position)
	tween.tween_property(self, "speed", 200, 1).set_ease(Tween.EASE_IN)
	tween.parallel().tween_property(self, "velocity", (player.global_position-position).normalized(), 1)
	$Line2D.started = true

func react():
	pass

func _on_turn_timer_timeout() -> void:
	_turn()

func _on_LifetimeTimer_timeout():
	queue_free()
