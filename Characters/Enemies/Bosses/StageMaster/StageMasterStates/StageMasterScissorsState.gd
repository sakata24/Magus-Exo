extends State

@export var STAGE_MASTER : Boss
@export var ATTACK_COOLDOWN : float

var attack_timer
var new_velocity
var collision : KinematicCollision2D

var target_aquired := false
var hit_this_attack := false

func enter():
	STAGE_MASTER.invincible = false
	attack_timer = Timer.new()
	attack_timer.autostart = false
	attack_timer.one_shot = true
	attack_timer.connect("timeout", on_attack_timer_timeout)
	add_child(attack_timer)
	attack_timer.start(2)
	STAGE_MASTER.get_node("AnimationPlayer").play("scissors_moving")

func on_attack_timer_timeout():
	STAGE_MASTER.speed = 7
	new_velocity = STAGE_MASTER.global_position.direction_to(STAGE_MASTER.player.global_position) * STAGE_MASTER.speed
	if new_velocity.x > 0:
		STAGE_MASTER.flip(true)
	elif new_velocity.x < 0:
		STAGE_MASTER.flip(false)
	target_aquired = true
	hit_this_attack = false

func physics_update(delta):
	if target_aquired:
		collision = STAGE_MASTER.move_and_collide(new_velocity)
	if collision:
		if collision.get_collider() is Player && not hit_this_attack:
			STAGE_MASTER.player.hit(DamageObject.new())
			hit_this_attack = true
		if collision.get_collider() is TileMapLayer:
			target_aquired = false
			collision = null
			attack_timer.start()

func exit():
	attack_timer.queue_free()
