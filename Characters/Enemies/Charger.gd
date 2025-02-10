extends Monster

var lockTarget
var dashing = false
var canHit = true

# make the monster move
func _physics_process(delta):
	if can_move:
		if aggro and not attacking and not dashing:
			# if far, chase
			if global_position.distance_to(player.global_position) > 70:
				chase(delta)
			# else charge up dash
			else:
				chargeDash(delta)
		# make it dash
		else:
			if dashing:
				dash(delta)
	move_and_slide()

# chases the player
func chase(delta):
	var new_velocity = to_local($NavigationAgent2D.get_next_path_position()).normalized() * speed
	if new_velocity.x < 0:
		$Sprite2D.flip_h = true
	elif new_velocity.x > 0:
		$Sprite2D.flip_h = false
	set_velocity(new_velocity)
		

# charges up the dash with a timer
func chargeDash(delta):
	attacking = true
	set_velocity(Vector2.ZERO)
	# target PAST the player
	lockTarget = player.global_position - ((self.global_position - player.global_position).normalized()) * 1000
	if self.global_position.x - lockTarget.x > 0:
		$Sprite2D.flip_h = true
	else:
		$Sprite2D.flip_h = false
	$DamageArea.look_at(lockTarget)
	$DamageArea.visible = true
	$AttackTimer.start()
	
func dash(delta):
	var new_velocity = to_local(lockTarget).normalized() * speed * 4.5
	set_velocity(new_velocity)

func _on_attack_timer_timeout():
	dashing = true
	$DamageArea.visible = false
	$DashTimer.start()

func _on_dash_timer_timeout():
	set_velocity(Vector2.ZERO)
	dashing = false
	attacking = false

func _on_damage_area_body_entered(body):
	if body.name == "Player":
			body.hit(my_dmg)
