class_name LuminousEyeAttackingState extends State

@export var luminousEye: LuminousEye

func enter():
	var attack_choice = randi_range(0, 10)
	if attack_choice == 0:
		luminousEye.change_position()
	elif attack_choice < 4 and luminousEye.stage >= 2:
		luminousEye.cast_photon_laser(1)
	else:
		luminousEye.summon_photon_bullets((luminousEye.stage * 2) + 7, 1)

func _on_attack_finished():
	Transitioned.emit(self, "Idle")
