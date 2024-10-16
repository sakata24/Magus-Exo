extends Monster

@onready var Crystal = load("res://Characters/Enemies/BarrierCrystal.tscn")
@onready var Cannon = load("res://Abilities/BossMoves/Cannon.tscn")
@onready var Minion = load("res://Characters/Enemies/Monster.tscn")
@onready var Spike = load("res://Abilities/BossMoves/VolitileSpike.tscn")

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
	call_deferred("_get_playable_area")
	call_deferred("_set_player")

func _physics_process(delta: float) -> void:
	pass


func _get_playable_area():
	var rect = get_parent().get_node("NavigationRegion2D/TileMap").get_used_rect()
	rect.size.x -= 1
	rect.size.y -= 1
	rect.size.x *= 16
	rect.size.y *= 16
	rect.position.x = 16
	rect.position.y = 16
	playable_area = rect

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
func _hit(dmg_to_take, dmg_color):
	if invincible:
		var dmgNum = damageNumber.instantiate()
		dmgNum.modulate = dmg_color
		get_parent().add_child(dmgNum)
		dmgNum.set_value_and_pos(self.global_position, "Immune")
		emit_signal("health_changed", health, true)
	else:
		if (stage == 1 && health-dmg_to_take <= maxHealth/2):
			var dmgNum = damageNumber.instantiate()
			dmgNum.modulate = dmg_color
			get_parent().add_child(dmgNum)
			dmgNum.set_value_and_pos(self.global_position, health-maxHealth/2)
			invincible = true
			emit_signal("health_changed", maxHealth/2, true)
			$CannonTimer.stop()
			stage += 1
			begin_stage()
		else:
			health -= dmg_to_take
			var dmgNum = damageNumber.instantiate()
			dmgNum.modulate = dmg_color
			get_parent().add_child(dmgNum)
			dmgNum.set_value_and_pos(self.global_position, dmg_to_take)
			emit_signal("health_changed", health, false)


# when i die
func die():
	emit_signal("giveXp", bestowedXp)
	var drop
	match randi_range(0, 2):
		0: 
			print("pee")
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
		#Cannon Round
		1:
			invincible = false
			emit_signal("health_changed", health, false)
			$CannonTimer.start()
		#Second Crystal Round
		2:
			crystal_amount = 5
			get_tree().current_scene.get_node("CanvasModulate").visible = true
			await player.spawn_light()
			_spawn_crystals()
		#Spike Round
		3:
			invincible = false
			get_tree().current_scene.despawn_light()
			emit_signal("health_changed", health, false)
			$CannonTimer.start()
			$SpikeTimer.start()


func _fire_cannon():
	for n in 7:
		var inst = Cannon.instantiate()
		var pos : Vector2i
		pos.x = randi_range(playable_area.position.x, playable_area.size.x)
		pos.y = randi_range(playable_area.position.y, playable_area.size.y)
		inst.global_position = pos
		get_parent().add_child(inst)

func _fire_spike():
	# load the projectile
	var projectile = Spike.instantiate()
	# spawn the projectile and initialize it
	projectile.set_player(player, global_position)
	get_parent().add_child(projectile)
	# calculates the projectiles direction
	projectile.velocity = (player.global_position - projectile.position).normalized()
