class_name LuminousEyeAttackingState extends State

@export var luminousEye: LuminousEye

func enter():
	#var attack_choice = randi_range(0, 3)
	#if attack_choice == 0:
		#luminousEye.change_position()
	#elif attack_choice == 1:
		#luminousEye.summon_photon_bullets(1, 1)
	#else:
		#luminousEye.cast_photon_laser(1)
	luminousEye.summon_photon_bullets(5, 1)

func _on_attack_finished():
	Transitioned.emit(self, "Idle")
