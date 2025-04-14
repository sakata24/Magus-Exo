class_name LuminousEye extends Boss

var time: float
var mirror_spawn_area: Rect2 = Rect2()
var protected = false
var stage = 1
@onready var mirror_resource = load("res://Maps/MapElements/BossMapElements/LuminousMirror.tscn")
@onready var dodecahedron_sprite = $DodecahedronSprite

func _ready():
	maxHealth = 750
	health = 750
	boss_name = "Photonis, the Luminous Eye"
	super._ready()

# photon bullets - summons a cone of bullets
func summon_photon_bullets(num: int, bounces: int):
	pass

# photon laser - a laser that bounces off of mirrors
func cast_photon_laser(bounces: int):
	$PhotonLaser.charge(player.global_position)
	
# fractal barrier - makes the boss immune to damage until shield is broken
func enable_fractal_barrier():
	dodecahedron_sprite.modulate = Color(1, 0.745, 0.416, 1)
	protected = true

func fractal_barrier_broken():
	dodecahedron_sprite.modulate = Color(1, 1, 1, 0.47)
	protected = false

# parallax ability - teleports the boss to a new location
func change_position():
	$ParallaxFilter.visible = true
	var tween = Tween.new()
	

# hall of versailles - change the location of the mirrors
func randomize_mirrors():
	for mirror in get_tree().get_nodes_in_group("mirrors"):
		mirror.queue_free()
	for i in range(0, 17):
		var new_mirror: LuminousMirror = mirror_resource.instantiate()
		call_deferred("add_sibling", new_mirror)
		var rand_pos = 32 * Vector2(randi_range(1, 47), randi_range(1, 12))
		# ensure mirror is not on the boss
		while ((rand_pos.x > self.get_global_position().x-96) and (rand_pos.x < self.get_global_position().x+96)) and ((rand_pos.y > self.get_global_position().y-96) and (rand_pos.y < self.get_global_position().y+96)):
			rand_pos = 32 * Vector2(randi_range(1, 47), randi_range(1, 12))
		new_mirror.global_position = rand_pos
		new_mirror.mirror.facing = MirrorType.variant.values().pick_random()
		new_mirror.add_to_group("mirrors")

func _hit(damage: DamageObject):
	if not protected:
		super(damage)
	if damage.get_types().has("fracture"):
		pass

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
