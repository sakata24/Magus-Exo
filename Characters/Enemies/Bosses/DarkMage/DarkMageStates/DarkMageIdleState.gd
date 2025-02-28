class_name DarkMageIdleState extends State

func _ready() -> void:
	pass

func _go_invincible():
	Transitioned.emit(self, "Invincible")
