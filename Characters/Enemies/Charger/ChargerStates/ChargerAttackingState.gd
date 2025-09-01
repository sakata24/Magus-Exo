class_name ChargerAttackingState extends State

@export var charger: Charger
var chase_target: CharacterBody2D

func enter():
	charger.attacking = true
	var attack_timer = Timer.new()
	attack_timer.wait_time = charger.attack_timer_time
	add_child(attack_timer)
	attack_timer.name = "attack_timer"
	attack_timer.connect("timeout", on_attack_timer_timeout)
	attack_timer.start()
	show_damage_area()

func exit():
	charger.indicator.visible = false
	get_node("attack_timer").queue_free()

func update(delta: float):
	if charger.rotation > PI:
		charger.animation.flip_h = true
	else:
		charger.animation.flip_h = false
	charger.animation.look_at(charger.player.global_position)
	charger.dmg_area.look_at(charger.player.global_position)
	charger.hitbox.look_at(charger.player.global_position)
	charger.indicator.look_at(charger.player.global_position)

func physics_update(delta: float):
	if !charger.can_move:
		Transitioned.emit(self, "Stunned")
		return
	charger.set_velocity(Vector2.ZERO)

func on_attack_timer_timeout():
	Transitioned.emit(self, "Dashing")

func show_damage_area():
	charger.get_node("DamageArea/Indicator").visible = true
