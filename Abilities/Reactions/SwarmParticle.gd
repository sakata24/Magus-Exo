class_name SwarmParticle extends Area2D

# get my parent
@onready var swarm_parent: SwarmReaction = get_parent()
var target_location
var speed = 100

func _ready() -> void:
	find_target_location()

# hit a target if i collide with them
func _on_body_entered(body: Enemy) -> void:
	if body.is_in_group("monsters"):
		var damage_object = DamageObject.new()
		damage_object.init(1, ["growth", "wither"], get_parent().caster)
		body._hit(damage_object)

func _physics_process(delta: float) -> void:
	if position.distance_to(target_location) <= 1:
		find_target_location()
	position += position.direction_to(target_location) * speed * delta

# choose my location if need to
func find_target_location():
	var theta = randf() * 2 * PI
	var r = sqrt(randf()) * swarm_parent.swarm_radius
	target_location = Vector2(r * cos(theta), r * sin(theta))
