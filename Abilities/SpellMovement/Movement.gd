class_name Movement extends Node

# to be overridden. Moves the given spell with a velocity.
func move_to(ability: BaseTypeAbility, velocity: Vector2):
	pass

static func get_movement_object_by_name(name: String):
	match name:
		"bullet": return BulletMovement.new()
		"still" : return StillMovement.new()
		_: return Movement.new()
