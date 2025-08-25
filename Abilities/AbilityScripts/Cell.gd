class_name CellAbility extends GrowthAbility

var cell_burst_scene = load("res://Abilities/Reactions/CellBurst.tscn")

# Initial creation of object on load.
func init(skill_dict: Dictionary, cast_target: Vector2, caster: Node2D):
	myModifiers.append(CollisionDespawnModifier.new())
	super.init(skill_dict, cast_target, caster)

func _ready() -> void:
	$GrowthTimer.connect("timeout", _on_growth_timer_timeout)

# Increases the scale of this ability
func increase_scale(growth_float: float):
	scale += Vector2(growth_float, growth_float)

# Increase the dmg of this ability
func increase_dmg(growth_dmg: int):
	dmg += growth_dmg

# Handles the reaction effects.
func handle_reaction(reactant: Node2D):
	super(reactant)
	create_new_reaction(reactant)
	if reactant is SunderAbility:
		burst_caused(reactant)

# Called every time the growth timer is triggered
func _on_growth_timer_timeout() -> void:
	increase_scale(0.2)
	increase_dmg(1)
	
func burst_caused(reactant: SunderAbility):
	var cell_burst = cell_burst_scene.instantiate()
	add_sibling(cell_burst)
	cell_burst.position = position
	cell_burst.scale = scale
