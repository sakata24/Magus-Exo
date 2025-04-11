extends Area2D

@export var EXPAND_SPEED : float
@export var SHOCKWAVE_WIDTH : float

var radius : float

func _ready() -> void:
	radius = SHOCKWAVE_WIDTH
	_create_process_material()

func _physics_process(delta: float) -> void:
	radius += delta * EXPAND_SPEED

	# Update Collision shapes
	$DamageShape.shape.radius = radius + (SHOCKWAVE_WIDTH/2)
	$SafeShape.shape.radius = radius - (SHOCKWAVE_WIDTH/2)
	
	# Update Particles
	if $GPUParticles2D.process_material:
		await _update_process_material()
	
	# Call _draw
	queue_redraw()
	if radius > 500:
		queue_free()

func _draw() -> void:
	draw_arc(Vector2.ZERO, radius, 0, TAU, 500, Color.WHITE, SHOCKWAVE_WIDTH)

func _create_process_material():
	var mat = ParticleProcessMaterial.new()
	mat.lifetime_randomness = 0.5
	mat.emission_shape = ParticleProcessMaterial.EMISSION_SHAPE_RING
	mat.gravity.y = 0
	mat.scale_max = 2
	mat.angle_min = -180
	mat.angle_max = 180
	mat.initial_velocity_max = 20
	mat.spread = 180
	$GPUParticles2D.process_material = mat

func _update_process_material():
	$GPUParticles2D.process_material.emission_ring_inner_radius = radius + (SHOCKWAVE_WIDTH/2)
	$GPUParticles2D.process_material.emission_ring_radius = radius + (SHOCKWAVE_WIDTH/2)

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		if global_position.distance_to(body.global_position) < $SafeShape.shape.radius:
			print("Safe")
		else:
			body.hit(DamageObject.new(0))
