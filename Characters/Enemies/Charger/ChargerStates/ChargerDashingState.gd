class_name ChargerDashingState extends State

@export var charger: Charger

func enter():
	charger.dashing = true
	var dash_timer = Timer.new()
	dash_timer.wait_time = charger.dash_time
	add_child(dash_timer)
	dash_timer.name = "dash_timer"
	dash_timer.connect("timeout", on_dash_timer_timeout)
	dash_timer.start()

func exit():
	charger.dashing = false

func physics_update(delta: float):
	if !charger.can_move:
		Transitioned.emit(self, "Stunned")
		return
	var new_velocity = charger.to_local(charger.lock_target).normalized() * charger.speed * 4.5
	charger.velocity = new_velocity

func on_dash_timer_timeout():
	Transitioned.emit(self, "Chase")
