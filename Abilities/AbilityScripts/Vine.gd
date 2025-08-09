class_name VineSpell extends GrowthAbility

var vine_burst_scene = load("res://Abilities/Reactions/VineBurst.tscn")
@onready var tip_bone = $Skeleton2D/Bone1/Bone2/Bone3/Bone4/Bone5/Bone6/Bone7/Bone8/Bone9/Bone10
var BASE_SIZE: Vector2i = Vector2i(200, 4)

var MAX_ROTATION_SPEED: float = 2.5
var ROTATION_WEIGHT: float = 0.05

func init(skill_dict, cast_target, caster):
	super(skill_dict, cast_target, caster)
	set_angle_and_position(cast_target, caster.global_position)

# sets the angle and position of the spell
func set_angle_and_position(cast_target: Vector2, caster_position: Vector2):
	var target_position = caster_position + (caster_position.direction_to(cast_target) * 8) + (caster_position.direction_to(cast_target) * (BASE_SIZE.x/2))
	var target_angle = caster_position.direction_to(get_global_mouse_position()).angle()
	#var clamped_angle = clampf(target_angle, self.global_rotation - (PI/MAX_ROTATION_SPEED), self.global_rotation + (PI/MAX_ROTATION_SPEED))
	self.global_rotation = lerp_angle(global_rotation, target_angle, ROTATION_WEIGHT)
	#$Skeleton2D/Bone1.global_position = caster_position
	var clamped_vec = get_clamped_position(caster_position, target_position, BASE_SIZE.x/2)
	self.position.x = lerpf(position.x, clamped_vec.x, ROTATION_WEIGHT)
	self.position.y = lerpf(position.y, clamped_vec.y, ROTATION_WEIGHT)
	#$Skeleton2D/Bone1.global_position = cast_target
	#tip_bone.global_position = caster_position

func get_clamped_position(origin: Vector2, original: Vector2, radius: float):
	return origin + (origin.direction_to(original) * radius)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if spell_caster:
		set_angle_and_position(get_global_mouse_position(), spell_caster.global_position)

# Handles the reaction effects.
func handle_reaction(reactant: Node2D):
	super(reactant)
	create_new_reaction(reactant)
	if reactant is SunderAbility:
		burst_caused(reactant)

func burst_caused(reactant: SunderAbility):
	var vine_burst = vine_burst_scene.instantiate()
	add_child(vine_burst)
