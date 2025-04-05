@tool
class_name LuminousMirror extends Area2D

@export var enabled = true:
	set(new_var):
		enabled = new_var

### TOOL SCRIPT RELATED FUNCTIONS BELOW ###
@export var mirror: MirrorType = MirrorType.new():
	set(new_resource):
		if mirror != null:
			mirror.changed.disconnect(_on_resource_changed)
		mirror = new_resource
		mirror.changed.connect(_on_resource_changed)

func _on_resource_changed():
	$CollisionShape2D.shape = mirror.collision_shape
	$Sprite2D.texture = mirror.sprite
