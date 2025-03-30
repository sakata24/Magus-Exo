class_name ChargerDashingState extends State

@export var charger: Charger
@onready var animation: AnimatedSprite2D = charger.get_node("AnimatedSprite2D")

func enter():
	charger.dashing = true
	charger.wall_min_slide_angle = deg_to_rad(30)
	setup_dash_timer()

func exit():
	charger.dashing = false
	animation.set_animation("idle")
	var tween = get_tree().create_tween()
	tween.tween_property(charger, "rotation", 0.0, 0.2)
	charger.wall_min_slide_angle = deg_to_rad(0)

func physics_update(delta: float):
	if !charger.can_move:
		Transitioned.emit(self, "Stunned")
		return
	charger.velocity = Vector2(cos(charger.rotation), sin(charger.rotation)) * charger.speed * 4.5

func setup_dash_timer():
	var dash_timer = Timer.new()
	dash_timer.wait_time = charger.dash_time
	add_child(dash_timer)
	dash_timer.name = "dash_timer"
	dash_timer.connect("timeout", on_dash_timer_timeout)
	dash_timer.start()
	animation.set_animation("dashing")

func on_dash_timer_timeout():
	get_node("dash_timer").queue_free()
	Transitioned.emit(self, "Chase")
