class_name PhotonBullet extends BaseTypeAbility

signal attack_finished
@onready var parent = get_parent()

func _ready() -> void:
	abilityID = "PhotonBullet"
	speed = 400
	myMovement = Movement.get_movement_object_by_name("bullet")
	myModifiers.append(CollisionDespawnModifier.new())
	for modifier in myModifiers:
		modifier.apply(self)
	call_deferred("emit_signal", "attack_finished")

func _on_body_entered(body: Node2D):
	print(body)
	if body is Player:
		var dmg = DamageObject.new(3, [], parent)
		body.hit(dmg)
	elif body.get_parent() is LuminousMirror:
		self.speed += 100
		return
