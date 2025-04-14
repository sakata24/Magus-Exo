class_name StatusEffect extends Node2D

@onready var parent = get_parent()
@onready var duration_timer: Timer = Timer.new()
var duration: float
var caster

func init(init_duration: float, init_caster) -> void:
	duration = init_duration
	caster = init_caster

func _ready() -> void:
	duration_timer.wait_time = duration
	duration_timer.connect("timeout", _on_duration_timer_timeout)
	add_child(duration_timer)
	duration_timer.start()

func _on_duration_timer_timeout():
	queue_free()
