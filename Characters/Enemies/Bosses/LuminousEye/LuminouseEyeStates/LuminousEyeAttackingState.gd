class_name LuminousEyeAttackingState extends State

@export var luminousEye: LuminousEye

func enter():
	luminousEye.cast_photon_laser(1)

func _on_attack_finished():
	Transitioned.emit(self, "Idle")
