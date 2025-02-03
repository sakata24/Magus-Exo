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
func _hit(dmg_to_take, dmg_type_1, dmg_type_2, caster):
	print(health)
	if not invincible:
		# reduce my hp
		health -= dmg_to_take
		#Sunder: #7a0002
		#Entropy: #ffd966
		#Growth: #36c72c
		#Construct: #663c33
		#Flow: #82b1ff
		#Wither: #591b82
		var dmg_color_1 = Color.WHITE
		var dmg_color_2 = Color.WHITE
		match dmg_type_1:
			"sunder": dmg_color_1 = Color("#7a0002")
			"entropy": dmg_color_1 = Color("#ffd966")
			"growth": dmg_color_1 = Color("#36c72c")
			"construct": dmg_color_1 = Color("#663c33")
			"flow": dmg_color_1 = Color("#82b1ff")
			"wither": dmg_color_1 = Color("#591b82")
		match dmg_type_2:
			"sunder": dmg_color_2 = Color("#7a0002")
			"entropy": dmg_color_2 = Color("#ffd966")
			"growth": dmg_color_2 = Color("#36c72c")
			"construct": dmg_color_2 = Color("#663c33")
			"flow": dmg_color_2 = Color("#82b1ff")
			"wither": dmg_color_2 = Color("#591b82")
		var dmgNum = damageNumber.instantiate()
		dmgNum.set_colors(dmg_color_1, dmg_color_2)
		get_parent().add_child(dmgNum)
		dmgNum.set_value_and_pos(dmg_to_take, self.global_position)
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
