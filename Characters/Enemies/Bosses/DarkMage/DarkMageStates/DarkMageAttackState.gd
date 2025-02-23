class_name DarkMageIcathianRainState extends State

@onready var Spike = load("res://Abilities/BossMoves/VolitileSpike.tscn")
@onready var Cannon = load("res://Abilities/BossMoves/Cannon.tscn")

@export var DarkMage: Monster 
@export var SPIKE_TIMER : float = 2.0 ## The time in between the firing of spikes
@export var CANNON_TIMER : float = 0.4 ## The time in between the firing of spikes
@export var CANNON_AMOUNT : int = 5 ## The amount of cannon spawns per attack

func enter():
	# Turn off invincibility
	DarkMage.invincible = false
	DarkMage.emit_signal("health_changed", DarkMage.health, false) # In the UI
	
	# Create new timer for spikes
	var spike_timer = Timer.new()
	spike_timer.wait_time = SPIKE_TIMER
	add_child(spike_timer)
	spike_timer.name = "attack_timer"
	
	# Create new timer for cannon
	var cannon_timer = Timer.new()
	cannon_timer.wait_time = CANNON_TIMER
	add_child(cannon_timer)
	cannon_timer.name = "attack_timer"
	
	# Connect timers
	spike_timer.connect("timeout", _on_spike_timer_timeout)
	cannon_timer.connect("timeout", _on_cannon_timer_timeout)
	
	#Start timers
	spike_timer.start()
	if DarkMage.invincible_stage > 1:
		cannon_timer.start()

func exit():
	get_node("attack_timer").queue_free()
	DarkMage.invincible_stage += 1

func _on_spike_timer_timeout():
	# load the projectile
	var projectile = Spike.instantiate()
	# spawn the projectile and initialize it
	projectile.set_player(DarkMage.player, DarkMage.global_position)
	get_parent().add_child(projectile)
	projectile.add_to_group("skills")
	projectile.add_to_group("enemy_skills")
	# calculates the projectiles direction
	projectile.velocity = (DarkMage.player.global_position - projectile.position).normalized()

func _on_cannon_timer_timeout():
	for n in CANNON_AMOUNT:
		var inst = Cannon.instantiate()
		var pos : Vector2i
		pos.x = randi_range(DarkMage.player.global_position.x - DarkMage.CANNON_SPAWN_RADIUS, DarkMage.player.global_position.x + DarkMage.CANNON_SPAWN_RADIUS)
		pos.y = randi_range(DarkMage.player.global_position.y - DarkMage.CANNON_SPAWN_RADIUS, DarkMage.player.global_position.y + DarkMage.CANNON_SPAWN_RADIUS)
		inst.global_position = pos
		get_parent().add_child(inst)

func go_invincible():
	Transitioned.emit(self, "Invincible")
	DarkMage.invincible_stage += 1
