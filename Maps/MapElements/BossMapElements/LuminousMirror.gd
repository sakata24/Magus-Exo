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
	$StaticBody2D/CollisionPolygon2D.polygon = mirror.map_hitbox
	$CollisionShape2D.position.y = mirror.offset
	$Sprite2D.position.y = mirror.offset
	$StaticBody2D.position.y = mirror.offset

func _on_area_entered(area: Area2D) -> void:
	if area is PhotonBullet:
		if area.collision_count <= 0:
			return
		else:
			area.collision_count -= 1
			area.set_rotation(Vector2(cos(area.rotation), sin(area.rotation)).bounce(mirror.perpendicular_angle).angle())
			if area.collision_count <= 0:
				area.get_node("Texture").color.g = 0.40
