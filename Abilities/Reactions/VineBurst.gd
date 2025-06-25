class_name VineBurstReaction extends Reaction

var burn_status_effect_scene = load("res://Characters/StatusEffects/BurnStatusEffect.tscn")
var MIN_PARTICLES = 8
@onready var parent: VineSpell = get_parent()
var particle_spawn_area

func _ready() -> void:
	setup_particle_spawn_box()
	parent.get_node("AnimatedSprite2D").modulate = Color(0.769, 0.345, 0.153)
	# spawn reaction name
	spawn_reaction_name("vine-burst!", parent, AbilityColor.GROWTH, AbilityColor.SUNDER)

func setup_particle_spawn_box():
	var vine_shape = parent.get_node("CollisionPolygon2D").get_polygon()
	var x_size
	var x_min = 9999
	var x_max = 0
	var y_min = 9999
	var y_max = 0
	for point: Vector2 in vine_shape:
		if point.x > x_max:
			x_max = point.x
		if point.x < x_min:
			x_min = point.x
		if point.y > y_max:
			y_max = point.y
		if point.y < y_min:
			y_min = point.y
	x_size = x_max - x_min
	$GPUParticles2D.get_process_material().emission_box_extents.x = x_size/2.0
	$GPUParticles2D.amount = (MIN_PARTICLES * x_size)/64.0

func _physics_process(delta: float) -> void:
	if parent.has_overlapping_bodies():
		for body in parent.get_overlapping_bodies():
			if body is Enemy and !body.has_node("BurnStatusEffect"):
				var burn_status_effect: BurnStatusEffect = burn_status_effect_scene.instantiate()
				burn_status_effect.init(3, parent.spell_caster)
				body.add_child(burn_status_effect)
