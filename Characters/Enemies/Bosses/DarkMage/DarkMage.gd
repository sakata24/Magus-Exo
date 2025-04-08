class_name DarkMage extends Boss

@onready var Minion = load("res://Characters/Enemies/Monster/Monster.tscn")

@export var CANNON_SPAWN_RADIUS : int = 100
@export var CRYSTAL_AMOUNT_PER_STAGE : Array = [4, 5]

var invincible_stage = 0
var invincible : bool = true
var current_crystal_amount : int
var playable_area : Rect2
var time: float
@onready var spell_cast_location: Node2D = $CastLocation

signal health_changed
signal boss_dead

func _ready():
	cc_immune = true
	# can i drop upgrades
	droppable = false
	maxHealth = 500
	add_to_group("monsters")
	await call_deferred("_set_player")
	_connect_to_HUD("Umbrae, Fractured Mage")
	$StateMachine/Idle._go_invincible()

# override so i just chill in the center and float
func _physics_process(delta: float) -> void:
	time += delta
	position.y += sin(time * 2.5) * 0.25

# hit by something
func _hit(damage: DamageObject):
	if invincible:
		# Spawn "Immune" damage number
		var dmgNum = damageNumber.instantiate()
		dmgNum.set_colors(AbilityColor.get_color_by_string(damage.get_type(0)), AbilityColor.get_color_by_string(damage.get_type(1)))
		get_parent().add_child(dmgNum)
		dmgNum.set_value_and_pos("Immune", self.global_position)
		# Update UI
		emit_signal("health_changed", health, true)
	else: #Hitting the half health threshold
		if (invincible_stage == 0 && health-damage.get_value() <= maxHealth/2):
			super(damage)
			$StateMachine/Attack.go_invincible()
		else:
			super(damage)
			emit_signal("health_changed", health, false)


# when i die
func die():
	emit_signal("give_xp", bestowedXp)
	emit_signal("boss_dead")
	player.get_parent().get_node("HUD").get_node("MarginContainer/BossBar").visible = false # CHANGE THIS AFTER UI REFACTORING 
	var drop
	match randi_range(0, 2):
		0: 
			drop = upgradeDrop.instantiate()
		_:
			drop = null
	if drop != null:
		drop.position = position
		get_parent().add_child(drop)
	for enemy in get_tree().get_nodes_in_group("monsters"):
		enemy.queue_free()
	queue_free()


func surround_player_with_minions():
	var player_pos = player.global_position
		#Spawn Minions around the player
	for i in (3):
		var rad = deg_to_rad(360/(5) * i - 45)
		var inst: Enemy = Minion.instantiate()
		inst.global_position.x = player_pos.x + cos(rad) * 50
		inst.global_position.y = player_pos.y + sin(rad) * 50
		get_parent().call_deferred("add_child", inst)
		inst.droppable = false

func toggle_lights(on : bool):
	if on:
		player.get_node("Light2D").visible = true
		get_parent().get_node("CanvasModulate").visible = true
	else:
		player.get_node("Light2D").visible = false
		get_parent().get_node("CanvasModulate").visible = false
