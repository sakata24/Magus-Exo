class_name ImportantItemIndicator extends VisibleOnScreenNotifier2D

@onready var indicator_sprite = $Sprite2D
## The texture to display to the player
@export var texture: Texture
## The size of the sprite
@export var sprite_scale: float = 1.0
## The distance from the center of the indicator the arrow should be placed
@export var arrow_offset: int = 20
var interval = 0.01

func _ready() -> void:
	if texture:
		indicator_sprite.texture = texture
	else:
		indicator_sprite.texture = PlaceholderTexture2D.new()
	$Sprite2D.scale = Vector2(sprite_scale, sprite_scale)
	$Sprite2D/Pivot/Arrow.position.x = arrow_offset
	$Sprite2D/Pivot/Arrow.scale = Vector2(1.0/sprite_scale, 1.0/sprite_scale)

func _process(delta: float) -> void:
	$Sprite2D/Pivot.look_at(get_parent().global_position)
	var player_pos = get_tree().get_nodes_in_group("players")[0].global_position
	var indicator_pos: Vector2 = indicator_sprite.global_position
	indicator_sprite.global_position = player_pos + (get_parent().global_position - player_pos).normalized() * 50
	$Sprite2D.modulate.a = $Sprite2D.modulate.a + interval
	if $Sprite2D.modulate.a >= 0.9:
		interval = -0.01
	elif $Sprite2D.modulate.a < 0.4:
		interval = 0.01

func _on_screen_entered() -> void:
	indicator_sprite.visible = false

func _on_screen_exited() -> void:
	indicator_sprite.visible = true
