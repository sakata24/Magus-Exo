class_name ImportantItemIndicator extends VisibleOnScreenNotifier2D

@onready var indicator_sprite = $Sprite2D
@export var texture: Texture

func _ready() -> void:
	if texture:
		indicator_sprite.texture = texture
	else:
		indicator_sprite.texture = PlaceholderTexture2D.new()

func _process(delta: float) -> void:
	$Sprite2D/Pivot.look_at(get_parent().global_position)
	var screen = get_viewport().get_visible_rect()
	#print(screen)
	indicator_sprite.global_position.x = clampf(indicator_sprite.global_position.x, screen.position.x, screen.end.x)
	indicator_sprite.global_position.y = clampf(indicator_sprite.global_position.y, screen.position.y, screen.end.y)

func _on_screen_entered() -> void:
	indicator_sprite.visible = false

func _on_screen_exited() -> void:
	indicator_sprite.visible = true
