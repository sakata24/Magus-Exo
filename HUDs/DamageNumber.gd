extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_value_and_pos(pos, dmg):
	self.global_position = pos
	$DmgText.text = str(dmg)
	$Outline.text = str(dmg)
	var tween = get_tree().create_tween()
	var end_pos = Vector2(randf_range(-7, 7), -10) + pos
	tween.tween_property(self, "global_position", end_pos, 0.9)

func _on_timer_timeout():
	self.queue_free()

func set_colors(color_1: Color, color_2: Color):
	var colors = PackedColorArray()
	colors.append(color_1)
	colors.append(color_2)
	$DmgText/TextureRect.texture.gradient.colors = colors
