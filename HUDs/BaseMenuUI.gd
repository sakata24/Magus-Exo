extends Control

@export var highlightSpeed := 500

func _ready() -> void:
	set_process(false)

func _process(delta: float) -> void:
	$HighlightHolder/VisibleOnScreenNotifier2D.position.x += delta * highlightSpeed
	$HighlightHolder/VisibleOnScreenNotifier2D.position.y += delta * highlightSpeed

func _on_highlight_timer_timeout() -> void:
	set_process(true)

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	set_process(false)
	$HighlightHolder/VisibleOnScreenNotifier2D.position = Vector2(0,0)
	$HighlightHolder/HighlightTimer.start(randi_range(3, 7))
