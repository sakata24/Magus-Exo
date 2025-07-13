class_name PhotonBullet extends BaseTypeAbility

signal attack_finished
var collision_count

func _ready() -> void:
	abilityID = "PhotonBullet"
	speed = 125
	myMovement = Movement.get_movement_object_by_name("bullet")
	myModifiers.append(CollisionDespawnModifier.new())
	element = "fracture"
	dmg = 3
	spell_caster = get_parent()
	for modifier in myModifiers:
		modifier.apply(self)
	call_deferred("emit_signal", "attack_finished")

func _on_body_entered(body: Node2D):
	if (body is Player) or (body is LuminousEye):
		var dmg_obj = DamageObject.new(dmg, [element], spell_caster)
		body.hit(dmg_obj)
