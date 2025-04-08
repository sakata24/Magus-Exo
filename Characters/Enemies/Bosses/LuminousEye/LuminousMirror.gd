@tool
class_name LuminousMirror extends Area2D

@export var enabled = true:
	set(new_var):
		enabled = new_var

### TOOL SCRIPT RELATED FUNCTIONS BELOW ###
@export var mirror: MirrorType:
	set(new_resource):
		if mirror != null:
			mirror.changed.disconnect(_on_resource_changed)
		mirror = new_resource
		mirror.changed.connect(_on_resource_changed)

func _init() -> void:
	mirror = MirrorType.new()

func _ready() -> void:
	update_hitbox_and_sprite()

func _on_resource_changed():
	update_hitbox_and_sprite()

func update_hitbox_and_sprite():
	$CollisionShape2D.shape = mirror.collision_shape
	$Sprite2D.texture = mirror.sprite
	$CollisionShape2D.position.y = mirror.offset
	$Sprite2D.position.y = mirror.offset

func _on_area_entered(area: Area2D) -> void:
	print("init: " + str(area.rotation_degrees))
	print("" + str(mirror.perpendicular_angle))
	print("Vector of incidence: " + str(Vector2(sin(area.rotation), cos(area.rotation))))
	area.look_at(10 * (Vector2(sin(area.rotation), cos(area.rotation)).bounce(mirror.perpendicular_angle)))
	print("result: " + str(area.rotation_degrees))
	#print(mirror.perpendicular_angle)
	
