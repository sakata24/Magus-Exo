class_name LuminousEyeIdleState extends State

@export var luminousEye: LuminousEye

func _ready() -> void:
	pass

func enter():
	luminousEye.get_node("IdleTimer").start()

func physics_update(delta: float):
	# on health threshold reached change phases and teleport
	luminousEye.get_node("ProjectilePivot").look_at(luminousEye.player.global_position)
	pass

func update(delta: float):
	luminousEye.get_node("EyeSprite").look_at(luminousEye.player.global_position)

func _on_idle_timer_timeout():
	Transitioned.emit(self, "Attack")
