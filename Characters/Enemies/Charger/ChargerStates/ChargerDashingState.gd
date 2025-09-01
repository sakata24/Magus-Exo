class_name ChargerDashingState extends State

@export var charger: Charger

func enter():
	charger.dashing = true
	charger.wall_min_slide_angle = deg_to_rad(180)
	charger.get_node("DamageArea").set_collision_mask_value(1, true)
	setup_dash_timer()

func exit():
	charger.dashing = false
	charger.animation.set_animation("idle")
	charger.velocity *= 1.0/(charger.speed_multiplier * 1.2)
	var tween = get_tree().create_tween()
	tween.tween_property(charger.animation, "rotation", 0.0, charger.attack_timer_time)
	tween.parallel().tween_property(charger.hitbox, "rotation", 0.0, charger.attack_timer_time)
	tween.parallel().tween_property(charger.dmg_area, "rotation", 0.0, charger.attack_timer_time)
	tween.parallel().tween_property(charger.indicator, "rotation", 0.0, charger.attack_timer_time)
	tween.play()
	charger.get_node("DamageArea").set_collision_mask_value(1, false)
	charger.wall_min_slide_angle = deg_to_rad(0)
	charger.did_hit = false

func physics_update(delta: float):
	if !charger.can_move:
		Transitioned.emit(self, "Stunned")
		return
	charger.velocity = Vector2(cos(charger.animation.rotation), sin(charger.animation.rotation)) * charger.speed * charger.speed_multiplier

func setup_dash_timer():
	var dash_timer = Timer.new()
	dash_timer.wait_time = charger.dash_time
	add_child(dash_timer)
	dash_timer.name = "dash_timer"
	dash_timer.connect("timeout", on_dash_timer_timeout)
	dash_timer.start()
	charger.animation.set_animation("dashing")

func on_dash_timer_timeout():
	get_node("dash_timer").queue_free()
	Transitioned.emit(self, "Reeling")
