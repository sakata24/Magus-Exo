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

func _ready():
	maxHealth = 500
	boss_name = "Umbrae, Fractured Mage"
	super._ready()
	$StateMachine/Idle._go_invincible()

# override so i just chill in the center and float
func _physics_process(delta: float) -> void:
	time += delta
	position.y += sin(time * 2.5) * 0.25

# hit by something
func hit(damage: DamageObject):
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


func surround_player_with_minions():
	var player_pos = player.global_position
		#Spawn Minions around the player
	for i in (5):
		var rad = deg_to_rad(360/(5) * i - 45)
		var inst: Enemy = Minion.instantiate()
		inst.global_position.x = player_pos.x + cos(rad) * 50
		inst.global_position.y = player_pos.y + sin(rad) * 50
		get_parent().call_deferred("add_child", inst)
		inst.droppable = false
