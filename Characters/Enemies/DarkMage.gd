extends Monster

@onready var Crystal = load("res://Characters/Enemies/BarrierCrystal.tscn")
@onready var Cannon = load("res://Abilities/BossMoves/Cannon.tscn")
@onready var Minion = load("res://Characters/Enemies/Monster.tscn")

var stage = 0
var invincible := true
var crystal_amount := 4
var playable_area : Rect2

signal health_changed

func _ready():
	speed = 0
	baseSpeed = 0
	health = 9000
	maxHealth = 9000
	add_to_group("monsters")
	_spawn_crystals()
	call_deferred("_get_playable_area")
	call_deferred("_set_player")
	print(playable_area)

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
	else:
		health -= dmg_to_take
		print("i took ", dmg_to_take, " dmg")
		var dmgNum = damageNumber.instantiate()
		dmgNum.modulate = dmg_color
		get_parent().add_child(dmgNum)
		dmgNum.set_value_and_pos(self.global_position, dmg_to_take)
		if health <= maxHealth - (maxHealth/3)*stage + 1:
			invincible = true
			$AttackTimer.stop()
			stage += 1
			end_stage()


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
	if crystal_amount == 0:
		begin_stage()
	else:
		var player_pos = player.global_position
		#Spawn Minions
		for i in (crystal_amount+1):
			var rad = deg_to_rad(360/(crystal_amount+1) * i - 45)
			var inst = Minion.instantiate()
			inst.global_position.x = player_pos.x + cos(rad) * 50
			inst.global_position.y = player_pos.y + sin(rad) * 50
			get_parent().call_deferred("add_child", inst)
			inst.add_to_group("monsters")

func begin_stage():
	match stage:
		0:
			invincible = false
			$AttackTimer.start()
		1:
			pass
		2:
			pass

#Begin the Invincibility round
func end_stage():
	match stage:
		1:
			pass
		2:
			pass

func _on_attack_timer_timeout():
	match stage:
		0:
			for n in 5:
				var inst = Cannon.instantiate()
				var pos : Vector2i
				pos.x = randi_range(playable_area.position.x, playable_area.size.x)
				pos.y = randi_range(playable_area.position.y, playable_area.size.y)
				inst.global_position = pos
				get_parent().add_child(inst)
