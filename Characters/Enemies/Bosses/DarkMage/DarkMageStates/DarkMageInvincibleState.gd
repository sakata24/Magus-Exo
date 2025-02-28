class_name DarkMageInvincibleState extends State

@onready var Crystal = load("res://Characters/Enemies/Bosses/DarkMage/BarrierCrystal.tscn")

@export var DarkMage: Monster

var current_crystal_amount : int

func enter():
	# Turn on invincibility
	DarkMage.invincible = true
	DarkMage.emit_signal("health_changed", DarkMage.health, true)
	
	spawn_crystals()
	current_crystal_amount = DarkMage.CRYSTAL_AMOUNT_PER_STAGE[DarkMage.invincible_stage]

#Spawns barrier crystals for Invincible states
func spawn_crystals():
	for i in DarkMage.CRYSTAL_AMOUNT_PER_STAGE[DarkMage.invincible_stage]:
		# Get location to put crystals
		var rad = deg_to_rad(360/DarkMage.CRYSTAL_AMOUNT_PER_STAGE[DarkMage.invincible_stage] * i - 90)
		var inst = Crystal.instantiate()
		inst.global_position.x = DarkMage.global_position.x + cos(rad) * 150
		inst.global_position.y = DarkMage.global_position.y + sin(rad) * 150
		# Spawn crystals
		DarkMage.get_parent().call_deferred("add_child", inst)
		inst.connect("destroyed_crystal", _on_crystal_destroyed)
		inst.add_to_group("monsters")

func _on_crystal_destroyed():
	current_crystal_amount -= 1
	if current_crystal_amount == 0: #When the last crystal is destroyed
		Transitioned.emit(self, "Attack")
	else:
		DarkMage.surround_player_with_minions()
