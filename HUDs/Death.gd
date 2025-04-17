extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func setup():
	var tween = create_tween()
	$BackgroundDimmer.modulate.a = 0.0
	tween.tween_property($BackgroundDimmer, ":modulate:a", 0.5, 1.5)
	tween.play()
	get_tree().paused = true

func _on_button_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()
