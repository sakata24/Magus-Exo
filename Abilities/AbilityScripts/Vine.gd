class_name VineSpell extends GrowthAbility

var vine_burst_scene = load("res://Abilities/Reactions/VineBurst.tscn")

var MAX_ROTATION_SPEED: float = 2.5
var ROTATION_WEIGHT: float = 0.05

func init(skill_dict, cast_target, caster):
	super(skill_dict, cast_target, caster)
	set_angle_and_position(cast_target, caster.global_position)

# sets the angle and position of the spell
func set_angle_and_position(cast_target: Vector2, caster_position: Vector2):
	self.position = caster_position
	var target_angle = caster_position.direction_to(get_global_mouse_position()).angle()
	var clamped_angle = clampf(target_angle, self.global_rotation - (PI/MAX_ROTATION_SPEED), self.global_rotation + (PI/MAX_ROTATION_SPEED))
	self.global_rotation = lerp_angle(global_rotation, target_angle, ROTATION_WEIGHT)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	set_angle_and_position(get_global_mouse_position(), self.spell_caster.global_position)

# Handles the reaction effects.
func handle_reaction(reactant: Node2D):
	super(reactant)
	create_new_reaction(reactant)
	if reactant is SunderAbility:
		burst_caused(reactant)

func burst_caused(reactant: SunderAbility):
	var vine_burst = vine_burst_scene.instantiate()
	add_child(vine_burst)
