extends Monster

signal destroyed_crystal

var invincible := false

func _ready():
	maxHealth = 10
	health = 10
	speed = 0
	baseSpeed = 0
	add_to_group("monsters")

func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	pass

# hit by something
func _hit(dmg_to_take, dmg_color):
	if not invincible:
		health -= dmg_to_take
		print("i took ", dmg_to_take, " dmg")
		var dmgNum = damageNumber.instantiate()
		dmgNum.modulate = dmg_color
		get_parent().add_child(dmgNum)
		dmgNum.set_value_and_pos(self.global_position, dmg_to_take)
		if health <= 0:
			die()


# when i die
func die():
	set_collision_layer_value(2, false)
	set_collision_layer_value(4, false)
	invincible = true
	$GPUParticles2D.emitting = true
	var tween = create_tween()
	tween.tween_property($Sprite2D, "self_modulate", Color(1,1,1,0), $GPUParticles2D.lifetime).set_ease(Tween.EASE_IN)
	await get_tree().create_timer($GPUParticles2D.lifetime/2)
	emit_signal("destroyed_crystal")
	await tween.finished
	queue_free()
