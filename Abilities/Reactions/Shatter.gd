class_name ShatterReaction extends AreaReaction

var myParent
var dmg = 0
var max_size = Vector2(2, 2)

# Called when the node enters the scene tree for the first time.
func init(reaction_components: Dictionary):
	myParent = reaction_components["source"]
	dmg = myParent.dmg

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	modulate_alpha_down(0.03)

# decrease the alpha of the spell if not fully transparent already
func modulate_alpha_down(decrease_amt: float):
	$Sprite2D.modulate.a = $Sprite2D.modulate.a - decrease_amt
	if $Sprite2D.modulate.a < 0:
		$Sprite2D.modulate.a = 0

# resets the alpha to normal
func reset_modulate_alpha():
	$Sprite2D.modulate.a = 1

# will increase the scale of the shatter reaction, then validate such that it doesnt get too big
func increase_scale(growth_float: float):
	self.scale = self.scale + Vector2(growth_float, growth_float)

# clear if longer than .2 s
func _on_timer_timeout():
	myParent.queue_free()

# on dmg time out increase the scale and do damage
func _on_dmg_timer_timeout() -> void:
	reset_modulate_alpha()
	increase_scale(0.4)
	damage_overlapping_bodies()

# will damage overlapping bodies
func damage_overlapping_bodies():
	for body in get_overlapping_bodies():
		if body.is_in_group("monsters"):
			damage_enemy(body)

# will damage an enemy
func damage_enemy(enemy):
	enemy._hit(dmg, "sunder", "construct", myParent.spell_caster)

# on body enter
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("monsters"):
		damage_enemy(body)
