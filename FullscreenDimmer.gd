class_name FullscreenDimmer extends ColorRect

@onready var main = get_parent()

func _process(delta: float) -> void:
	self.global_position = main.get_node("Player").global_position - Vector2(self.size.x/2.0, self.size.y/2.0)

func blackout_screen():
	self.visible = true
	color.a = 1

func dim_screen(value: int):
	self.visible = true
	color.a = value

func transition(duration: float):
	self.visible = true
	blackout_screen()
	get_tree().paused = true
	await get_tree().create_timer(duration/2.0).timeout
	get_tree().paused = false
	var callback_tween = create_tween()
	callback_tween.tween_property(self, "color:a", 0.0, duration/2.0)
	callback_tween.tween_callback(func(): 
		self.visible = false)
	callback_tween.play()
