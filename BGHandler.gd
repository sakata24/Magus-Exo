class_name BGHandler extends CanvasModulate

@onready var main = get_parent()
@onready var bg_canvas_modulate = $ParallaxBackground/CanvasModulate

func blackout_screen():
	self.visible = true
	bg_canvas_modulate.visible = true
	self.color = Color(0, 0, 0, 1)
	bg_canvas_modulate.color = Color(0, 0, 0, 1)

func dim_screen(value: float):
	self.visible = true
	bg_canvas_modulate.visible = true
	self.color = Color(value, value, value, value)
	bg_canvas_modulate.color = Color(value, value, value, 1)

func transition(duration: float):
	self.visible = true
	blackout_screen()
	get_tree().paused = true
	await get_tree().create_timer(duration/2.0).timeout
	get_tree().paused = false
	var tween = create_tween()
	tween.tween_property(self, "color", Color(1, 1, 1, 1), duration/2.0)
	tween.parallel().tween_property(bg_canvas_modulate, "color", Color(1, 1, 1, 1), duration/2.0)
	tween.play()
	await tween.finished

func despawn_light(seconds: float):
	self.visible = true
	bg_canvas_modulate.visible = true
	var tween = create_tween()
	tween.tween_property(self, "color", Color(0,0,0,1), seconds)
	tween.parallel().tween_property(bg_canvas_modulate, "color", Color(0,0,0,1), seconds)
	tween.play()

func respawn_light(seconds: float):
	var tween = create_tween()
	tween.tween_property(self, "color", Color(1,1,1,1), seconds)
	tween.parallel().tween_property(bg_canvas_modulate, "color", Color(1,1,1,1), seconds)
	tween.play()
	await tween.finished
	self.visible = false
	self.color = Color(0,0,0,1)
	bg_canvas_modulate.visible = false
	bg_canvas_modulate.color = Color(0,0,0,1)
