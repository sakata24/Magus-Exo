# Erode:
# Creation: entropy + flow
# spawn an AOE that applies a debuff to enemies in the radius

class_name ErodeReaction extends AreaReaction

var BASE_SIZE = 32.0
var vulnerable_status_effect_scene = preload("res://Characters/StatusEffects/VulnerableStatusEffect.tscn")
var debuff_time: float = 4.0

func init(reaction_components: Dictionary):
	spawn_reaction_name("erode!", self, Color("#ffd966"), Color("#82b1ff"))
	super(reaction_components)

func _ready():
	if get_parent_bounding_radius() <= BASE_SIZE:
		$CollisionShape2D.shape.radius = get_parent_bounding_radius() + BASE_SIZE/2.0
		$GPUParticles2D.process_material.emission_sphere_radius = $CollisionShape2D.shape.radius
	self.reparent(get_parent().get_parent())

func _on_body_entered(body: Node2D) -> void:
	if body is Enemy:
		if body.has_node("VulnerableStatusEffect"):
			body.get_node("VulnerableStatusEffect").restart_debuff_timer()
		else:
			var vuln_status_effect: VulnerableStatusEffect = vulnerable_status_effect_scene.instantiate()
			vuln_status_effect.set_debuff_length(debuff_time)
			body.add_child(vuln_status_effect)

func _on_timeout_timer_timeout() -> void:
	self.queue_free()
