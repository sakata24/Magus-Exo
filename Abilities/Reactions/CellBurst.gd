class_name CellBurstReaction extends AreaReaction

var burn_status_effect_scene = load("res://Characters/StatusEffects/BurnStatusEffect.tscn")

func _ready() -> void:
	# spawn reaction name
	spawn_reaction_name("cell-burst!", self, AbilityColor.GROWTH, AbilityColor.SUNDER)

func _on_body_entered(body: Node2D) -> void:
	if body is Enemy :
		ignite_target(body)

func ignite_target(target: Enemy):
	var burn_effect: BurnStatusEffect = burn_status_effect_scene.instantiate()
	burn_effect.init(3, ReactionScript.caster)
	target.add_child(burn_effect)
	
func _on_timer_timeout() -> void:
	queue_free()
	
func _physics_process(delta: float) -> void:
	scale += Vector2(0.2, 0.2)
