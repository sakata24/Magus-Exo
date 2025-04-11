@tool
class_name MirrorType extends Resource

var atlas_image = load("res://Resources/abilities/enemy/mirror.png")

var collision_shape: SegmentShape2D
var sprite: AtlasTexture = AtlasTexture.new()

enum variant {
	FACING_SOUTH, 
	FACING_NORTH,
	FACING_EAST,
	FACING_WEST,
	FACING_NORTHEAST,
	FACING_SOUTHEAST,
	FACING_SOUTHWEST,
	FACING_NORTHWEST
	}

## The direction the mirror is facing.
@export var facing: variant:
		set(new_variant):
			facing = new_variant
			update_structure()
			update_sprite()
			update_perpendicular_angle()
			update_offset()
			update_map_hitbox()
			changed.emit()

var perpendicular_angle = Vector2(0, -1)
var offset = 12.0
var map_hitbox = PackedVector2Array([Vector2(-16, -13), Vector2(16, -13), Vector2(16, 10), Vector2(-16, 10)])

func _init() -> void:
	sprite.set_atlas(atlas_image)
	sprite.set_region(Rect2(0.0, 0.0, 32.0, 32.0))

func update_structure():
	var final_shape: SegmentShape2D = SegmentShape2D.new()
	match facing:
		variant.FACING_SOUTH, variant.FACING_NORTH: 
			final_shape.set_a(Vector2(-16.0, 0))
			final_shape.set_b(Vector2(16.0, 0))
		variant.FACING_EAST, variant.FACING_WEST:
			final_shape.set_a(Vector2(0, -16.0))
			final_shape.set_b(Vector2(0, 16.0))
		variant.FACING_NORTHEAST, variant.FACING_SOUTHWEST:
			final_shape.set_a(Vector2(-16.0, -8.0))
			final_shape.set_b(Vector2(16.0, 8.0))
		variant.FACING_SOUTHEAST, variant.FACING_NORTHWEST:
			final_shape.set_a(Vector2(-16.0, 8.0))
			final_shape.set_b(Vector2(16.0, -8.0))
	collision_shape = final_shape

func update_sprite():
	var rect_area: Rect2
	match facing:
		variant.FACING_SOUTH: rect_area = Rect2(0.0, 0.0, 32.0, 32.0)
		variant.FACING_NORTH: rect_area = Rect2(32.0, 0.0, 32.0, 32.0)
		variant.FACING_EAST: rect_area = Rect2(0.0, 32.0, 32.0, 32.0)
		variant.FACING_WEST: rect_area = Rect2(32.0, 32.0, 32.0, 32.0)
		variant.FACING_NORTHEAST: rect_area = Rect2(0.0, 64.0, 32.0, 32.0)
		variant.FACING_SOUTHEAST: rect_area = Rect2(32.0, 64.0, 32.0, 32.0)
		variant.FACING_SOUTHWEST: rect_area = Rect2(0.0, 96.0, 32.0, 32.0)
		variant.FACING_NORTHWEST: rect_area = Rect2(32.0, 96.0, 32.0, 32.0)
	sprite.set_region(rect_area)

func update_perpendicular_angle():
	match facing:
		variant.FACING_SOUTH: perpendicular_angle = Vector2(0, 1)
		variant.FACING_NORTH: perpendicular_angle = Vector2(0, -1)
		variant.FACING_EAST: perpendicular_angle = Vector2(1, 0)
		variant.FACING_WEST: perpendicular_angle = Vector2(-1, 0)
		variant.FACING_NORTHEAST: perpendicular_angle = Vector2(1.0/sqrt(5.0), -2.0/sqrt(5.0))
		variant.FACING_SOUTHEAST: perpendicular_angle = Vector2(1.0/sqrt(5.0), 2.0/sqrt(5.0))
		variant.FACING_SOUTHWEST: perpendicular_angle = Vector2(-1.0/sqrt(5.0), 2.0/sqrt(5.0))
		variant.FACING_NORTHWEST: perpendicular_angle = Vector2(-1.0/sqrt(5.0), -2.0/sqrt(5.0))

func update_offset():
	match facing:
		variant.FACING_SOUTH: offset = -10.0
		variant.FACING_NORTH: offset = -12.0
		variant.FACING_EAST: offset = -16.0
		variant.FACING_WEST: offset = -16.0
		variant.FACING_NORTHEAST: offset = -16.0
		variant.FACING_SOUTHEAST: offset = -16.0
		variant.FACING_SOUTHWEST: offset = -16.0
		variant.FACING_NORTHWEST: offset = -16.0

func update_map_hitbox():
	match facing:
		variant.FACING_SOUTH: map_hitbox = PackedVector2Array([Vector2(-16, -13), Vector2(16, -13), Vector2(16, 10), Vector2(-16, 10)])
		variant.FACING_NORTH: map_hitbox = PackedVector2Array([Vector2(-16, -10), Vector2(16, -10), Vector2(16, 12), Vector2(-16, 12)])
		variant.FACING_EAST: map_hitbox = PackedVector2Array([Vector2(-3, -16), Vector2(1, -16), Vector2(1, 16), Vector2(-3, 16)])
		variant.FACING_WEST: map_hitbox = PackedVector2Array([Vector2(-1, -16), Vector2(3, -16), Vector2(3, 16), Vector2(-1, 16)])
		variant.FACING_NORTHEAST: map_hitbox = PackedVector2Array([Vector2(-16, -16), Vector2(16, -1), Vector2(16, 16), Vector2(11, 16), Vector2(-16, 3)])
		variant.FACING_SOUTHEAST: map_hitbox = PackedVector2Array([Vector2(9, -16), Vector2(16, -16), Vector2(16, 0), Vector2(-16, 16), Vector2(-16, -3)])
		variant.FACING_SOUTHWEST: map_hitbox = PackedVector2Array([Vector2(-16, -16), Vector2(-9, -16), Vector2(16, -3), Vector2(16, 16), Vector2(-16, 0)])
		variant.FACING_NORTHWEST: map_hitbox = PackedVector2Array([Vector2(16, -16), Vector2(16, 3), Vector2(-11, 16), Vector2(-16, 16), Vector2(-16, -1)])
