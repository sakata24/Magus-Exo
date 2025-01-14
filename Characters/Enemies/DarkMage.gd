extends Monster

@onready var Crystal = load("res://Characters/Enemies/BarrierCrystal.tscn")
@onready var Cannon = load("res://Abilities/BossMoves/Cannon.tscn")
@onready var Minion = load("res://Characters/Enemies/Monster.tscn")
@onready var Spike = load("res://Abilities/BossMoves/VolitileSpike.tscn")

@export var CANNON_SPAWN_RADIUS : int = 100

var stage = 0
var invincible := true
var crystal_amount := 4
var playable_area : Rect2

signal health_changed

func _ready():
	speed = 0
	baseSpeed = 0
	health = 500
	maxHealth = 500
	add_to_group("monsters")
	_spawn_crystals()
	call_deferred("_set_player")

# override so i dont move
func _physics_process(delta: float) -> void:
	pass

func _set_player():
	player = get_parent().get_parent().get_parent().get_node("Player")
	var HUD = player.get_parent().get_node("HUD")
	connect("health_changed", HUD._on_boss_health_change)
	HUD.show_boss_bar("Dark Mage", health)
	emit_signal("health_changed", maxHealth, true)

#Spawns barrier crystals for stage 0 and 2
func _spawn_crystals():
	for i in crystal_amount:
		var rad = deg_to_rad(360/crystal_amount * i - 90)
		var inst = Crystal.instantiate()
		inst.global_position.x = global_position.x + cos(rad) * 150
		inst.global_position.y = global_position.y + sin(rad) * 150
		get_parent().call_deferred("add_child", inst)
		inst.connect("destroyed_crystal", _on_crystal_destroyed)

# hit by something
func _hit(dmg_to_take, dmg_type_1, dmg_type_2, caster):
	if invincible:
		var dmgNum = damageNumber.instantiate()
		var dmg_color_1 = Color.WHITE
		var dmg_color_2 = Color.WHITE
		match dmg_type_1:
			"sunder": dmg_color_1 = Color("#7a0002")
			"entropy": dmg_color_1 = Color("#ffd966")
			"growth": dmg_color_1 = Color("#36c72c")
			"construct": dmg_color_1 = Color("#663c33")
			"flow": dmg_color_1 = Color("#82b1ff")
			"wither": dmg_color_1 = Color("#591b82")
		match dmg_type_2:
			"sunder": dmg_color_2 = Color("#7a0002")
			"entropy": dmg_color_2 = Color("#ffd966")
			"growth": dmg_color_2 = Color("#36c72c")
			"construct": dmg_color_2 = Color("#663c33")
			"flow": dmg_color_2 = Color("#82b1ff")
			"wither": dmg_color_2 = Color("#591b82")
		dmgNum.set_colors(dmg_color_1, dmg_color_2)
		get_parent().add_child(dmgNum)
		dmgNum.set_value_and_pos("Immune", self.global_position)
		emit_signal("health_changed", health, true)
	else:
		if (stage == 1 && health-dmg_to_take <= maxHealth/2):
			super(dmg_to_take, dmg_type_1, dmg_type_2, caster)
			invincible = true
			emit_signal("health_changed", maxHealth/2, true)
			$CannonTimer.stop()
			stage += 1
			begin_stage()
		else:
			super(dmg_to_take, dmg_type_1, dmg_type_2, caster)
			emit_signal("health_changed", health, false)


# when i die
func die():
	emit_signal("give_xp", bestowedXp)
	var drop
	match randi_range(0, 2):
		0: 
			drop = upgradeDrop.instantiate()
		_:
			drop = null
	if drop != null:
		drop.position = position
		get_parent().add_child(drop)
	queue_free()


func _on_crystal_destroyed():
	crystal_amount -= 1
	if crystal_amount == 0: #When the last crystal is destroyed
		stage += 1
		begin_stage()
	else:
		var player_pos = player.global_position
		#Spawn Minions around the player
		for i in (5):
			var rad = deg_to_rad(360/(5) * i - 45)
			var inst = Minion.instantiate()
			inst.droppable = false
			inst.global_position.x = player_pos.x + cos(rad) * 50
			inst.global_position.y = player_pos.y + sin(rad) * 50
			get_parent().call_deferred("add_child", inst)
			inst.add_to_group("monsters")

func begin_stage():
	match stage:
		#Spike Round
		1:
			invincible = false
			emit_signal("health_changed", health, false)
			$SpikeTimer.start()
		#Second Crystal Round
		2:
			crystal_amount = 5
			get_tree().current_scene.get_node("CanvasModulate").visible = true
			await player.spawn_light()
			_spawn_crystals()
		#Cannon Round
		3:
			invincible = false
			get_tree().current_scene.despawn_light()
			emit_signal("health_changed", health, false)
			$CannonTimer.start()
			$SpikeTimer.start()


func _fire_cannon():
	for n in 5:
		var inst = Cannon.instantiate()
		var pos : Vector2i
		pos.x = randi_range(player.global_position.x - CANNON_SPAWN_RADIUS, player.global_position.x + CANNON_SPAWN_RADIUS)
		pos.y = randi_range(player.global_position.y - CANNON_SPAWN_RADIUS, player.global_position.y + CANNON_SPAWN_RADIUS)
		inst.global_position = pos
		get_parent().add_child(inst)

func _fire_spike():
	# load the projectile
	var projectile = Spike.instantiate()
	# spawn the projectile and initialize it
	projectile.set_player(player, global_position)
	get_parent().add_child(projectile)
	projectile.add_to_group("skills")
	projectile.add_to_group("enemy_skills")
	# calculates the projectiles direction
	projectile.velocity = (player.global_position - projectile.position).normalized()
