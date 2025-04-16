class_name LuminousEye extends Boss

var photon_laser_scene = load("res://Abilities/BossMoves/LuminousEye/PhotonLaser.tscn")
var photon_bullet_scene = load("res://Abilities/BossMoves/LuminousEye/PhotonBullet.tscn")
var mirror_resource = load("res://Maps/MapElements/BossMapElements/LuminousMirror.tscn")
var barrier_pickup_scene = load("res://Interactables/Boss/BarrierPickup.tscn")

var time: float
var mirror_spawn_area: Rect2 = Rect2()
var protected = false
var stage = 1
var cone_size = (PI/4.0)
@onready var dodecahedron_sprite = $DodecahedronSprite

func _ready():
	maxHealth = 750
	health = 750
	boss_name = "Photonis, the Luminous Eye"
	super._ready()

# photon bullets - summons a cone of bullets
func summon_photon_bullets(num: int, bounces: int):
	var delta = cone_size/(num-1)
	for i in range(0, num):
		var spawn_angle = ($ProjectilePivot.rotation - cone_size/2.0) + (delta * i)
		var spawn_pos = Vector2(cos(spawn_angle), sin(spawn_angle)) * $ProjectilePivot/SpellSpawnPos.position
		var photon_bullet: PhotonBullet = photon_bullet_scene.instantiate()
		photon_bullet.connect("attack_finished", $StateMachine/Attack._on_attack_finished)
		add_child(photon_bullet)
		photon_bullet.position = spawn_pos
		photon_bullet.rotation = spawn_angle
	

# photon laser - a laser that bounces off of mirrors
func cast_photon_laser(bounces: int):
	var photon_laser: PhotonLaser = photon_laser_scene.instantiate()
	add_child(photon_laser)
	if stage == 3:
		photon_laser.get_node("LaserTimer").wait_time = 0.7
	photon_laser.connect("attack_finished", $StateMachine/Attack._on_attack_finished)
	photon_laser.charge(player.global_position)
	
# fractal barrier - makes the boss immune to damage until shield is broken
func enable_fractal_barrier():
	dodecahedron_sprite.modulate = Color(0.8, 0.745, 0.416, 0.8)
	spawn_barrier_pickup()
	protected = true

func fractal_barrier_broken():
	dodecahedron_sprite.modulate = Color(1, 1, 1, 0.47)
	protected = false

func spawn_barrier_pickup():
	var rand_pos = 48 * Vector2(randi_range(1, 32), randi_range(1, 7))
	var barrier_pickup: BarrierPickup = barrier_pickup_scene.instantiate()
	add_sibling(barrier_pickup)
	barrier_pickup.global_position = rand_pos

# parallax ability - teleports the boss to a new location
func change_position():
	# blind player
	var color_rect = ColorRect.new()
	player.get_node("Camera2D").add_child(color_rect)
	color_rect.size.x = player.get_viewport_rect().size.x
	color_rect.size.y = player.get_viewport_rect().size.y
	color_rect.position.x = -color_rect.size.x/2.0
	color_rect.position.y = -color_rect.size.y/2.0
	color_rect.z_index = 2
	color_rect.color = Color(0, 0, 0)
	var blind_timer = Timer.new()
	blind_timer.connect("timeout", func(): 
		color_rect.queue_free())
	blind_timer.connect("timeout", $StateMachine/Attack._on_attack_finished)
	blind_timer.wait_time = 0.2
	color_rect.add_child(blind_timer)
	blind_timer.start()
	# teleport
	var new_pos = randi_range(100, 1435)
	position.x = new_pos
	# randomize mirrors
	randomize_mirrors()

# hall of versailles - change the location of the mirrors
func randomize_mirrors():
	for mirror in get_tree().get_nodes_in_group("mirrors"):
		mirror.queue_free()
	for i in range(0, 17):
		var new_mirror: LuminousMirror = mirror_resource.instantiate()
		new_mirror.mirror = MirrorType.new()
		call_deferred("add_sibling", new_mirror)
		var rand_pos = 48 * Vector2(randi_range(1, 32), randi_range(1, 8))
		# ensure mirror is not on the boss
		while ((rand_pos.x > self.get_global_position().x-96) and (rand_pos.x < self.get_global_position().x+96)) and ((rand_pos.y > self.get_global_position().y-96) and (rand_pos.y < self.get_global_position().y+96)):
			rand_pos = 48 * Vector2(randi_range(1, 32), randi_range(1, 7))
		new_mirror.global_position = rand_pos
		new_mirror.mirror.facing = MirrorType.variant.values().pick_random()
		new_mirror.add_to_group("mirrors")

func hit(damage: DamageObject):
	if not protected:
		super(damage)
		if stage == 1 and health < maxHealth * 0.667:
			stage = 2
			change_position()
			cone_size *= 2
			enable_fractal_barrier()
			$IdleTimer.wait_time = 2.8
		if stage == 2 and health < maxHealth * 0.333:
			stage = 3
			change_position()
			cone_size *= 2
			enable_fractal_barrier()
			$IdleTimer.wait_time = 1.8
		if health <= 0:
			die()
	elif damage.get_types().has("fracture"):
		fractal_barrier_broken()
	else:
		var dmgNum = damageNumber.instantiate()
		dmgNum.set_colors(AbilityColor.get_color_by_string(damage.get_type(0)), AbilityColor.get_color_by_string(damage.get_type(1)))
		get_parent().add_child(dmgNum)
		dmgNum.set_value_and_pos("Immune", self.global_position)
		# Update UI
		emit_signal("health_changed", health, true)

# override so i just chill in the center and float
func _physics_process(delta: float) -> void:
	time += delta
	position.y += sin(time * 2.5) * 0.1
	$EyeSprite.position.y += sin((time + 0.5) * 2.5) * 0.07

func _process(delta: float) -> void:
	pass

func _on_fight_trigger_area_body_entered(body: Node2D) -> void:
	if body is Player:
		randomize_mirrors()
		$FightTriggerArea.set_collision_mask_value(1, false)
