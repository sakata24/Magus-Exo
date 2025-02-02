class_name DischargeReaction extends AreaReaction

const BASE_EMISSION_RADIUS = 64
const BASE_DISCHARGE_RADIUS = 20

# Called when the node enters the scene tree for the first time.
func _ready():
	set_discharge_size()
	init_particles()

func init(reaction_components: Dictionary):
	spawn_reaction_name("discharge!", get_parent(), Color("#ffd966"), Color("#663c33"))

# calculate and set the discharge reaction size
func set_discharge_size():
	# loop thru parent collision polygon vectors and use the furthest to calculate discharge radius
	var furthest_distance_from_center
	for point in get_parent().get_node("CollisionPolygon2D").polygon:
		furthest_distance_from_center = max(abs(point.x - self.position.x), abs(point.y - self.position.y))
	$CollisionShape2D.shape.radius = furthest_distance_from_center + BASE_DISCHARGE_RADIUS

# ready up the particle generator for the discharge reaction
func init_particles():
	var discharge_size = $CollisionShape2D.shape.radius
	$CPUParticles2D.emission_sphere_radius = discharge_size + BASE_DISCHARGE_RADIUS
	$CPUParticles2D.scale_amount_min = (discharge_size) / BASE_EMISSION_RADIUS
	$CPUParticles2D.scale_amount_max = (discharge_size + BASE_DISCHARGE_RADIUS) / BASE_EMISSION_RADIUS

# timer to tick on all monsters in the area
func _on_attack_timer_timeout():
	for body in get_overlapping_bodies():
		if body.is_in_group("monsters"):
			body._hit(5 + floor(get_parent().dmg/6), "entropy", "construct", get_parent().spell_caster)
