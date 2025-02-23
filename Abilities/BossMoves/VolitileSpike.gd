extends BaseTypeAbility

@onready var Rain = preload("res://Abilities/BossMoves/IcathianRain.tscn")

var player : Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	speed = 50
	dmg = 50
	timeout = 1
	lifetime = 10
	$LifetimeTimer.wait_time = lifetime
	scale *= 4
	$LifetimeTimer.start()
	myMovement = Movement.get_movement_object_by_name("bullet")

func set_player(p : Player, pos : Vector2):
	player = p
	global_position = pos
	look_at(player.global_position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	handle_movement(delta)

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
	queue_free()
	pass


func _on_LifetimeTimer_timeout():
	queue_free()
