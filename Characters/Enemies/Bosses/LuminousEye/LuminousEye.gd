class_name LuminousEye extends Boss

var time: float

func _ready():
	cc_immune = true
	# can i drop upgrades
	droppable = false
	maxHealth = 500
	add_to_group("monsters")
	await call_deferred("_set_player")
	_connect_to_HUD("Photonis, the Luminous Eye")

# photon bullets - summons a cone of bullets
func summon_photon_bullets(num: int, bounces: int):
	pass

# photon laser - a laser that bounces off of mirrors
func cast_photon_laser(bounces: int):
	pass

# fractal barrier - makes the boss immune to damage until shield is broken
func enable_fractal_barrier():
	pass

# parallax ability - teleports the boss to a new location
func change_position():
	pass

# hall of versailles - change the location of the mirrors
func randomize_mirrors():
	pass

func _hit(damage: DamageObject):
	if damage.get_types().has("fracture"):
		pass

# override so i just chill in the center and float
func _physics_process(delta: float) -> void:
	time += delta
	position.y += sin(time * 2.5) * 0.1
