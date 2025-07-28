# Discharge:
# Creation: construct + entropy
# spawn a damaging AOE around the source spell

class_name DischargeReaction extends AreaReaction

const BASE_EMISSION_RADIUS = 64
const BASE_DISCHARGE_RADIUS = 20

# Called when the node enters the scene tree for the first time.
func _ready():
	if multiplayer.is_server():
		set_discharge_size()
		ReactionScript.parents["source"].connect("tree_exited", queue_free)

func init(reaction_components: Dictionary):
	super(reaction_components)
	ReactionScript.parents["source"].add_sibling(self, true)
	spawn_reaction_name("discharge!", reaction_components["source"], Color("#ffd966"), Color("#663c33"))
	init_particles.rpc($CollisionShape2D.shape.radius)

func _physics_process(delta: float) -> void:
	if multiplayer.is_server():
		if ReactionScript.parents["source"]:
			self.global_position = ReactionScript.parents["source"].global_position

# calculate and set the discharge reaction size
func set_discharge_size():
	# loop thru parent collision polygon vectors and use the furthest to calculate discharge radius
	$CollisionShape2D.shape.radius = get_parent_bounding_radius() + BASE_DISCHARGE_RADIUS

# ready up the particle generator for the discharge reaction
@rpc("any_peer", "call_local", "unreliable")
func init_particles(collision_radius: float = 0.0):
	$CPUParticles2D.emission_sphere_radius = BASE_DISCHARGE_RADIUS + collision_radius
	$CPUParticles2D.scale_amount_min = (collision_radius) / BASE_EMISSION_RADIUS
	$CPUParticles2D.scale_amount_max = (collision_radius + BASE_DISCHARGE_RADIUS) / BASE_EMISSION_RADIUS

# timer to tick on all monsters in the area
func _on_attack_timer_timeout():
	for body in get_overlapping_bodies():
		if body.is_in_group("monsters"):
			var damage_object = DamageObject.new(5 + floor(get_parent().dmg/6), ["entropy", "construct"], get_parent().spell_caster)
			body.hit(damage_object)
