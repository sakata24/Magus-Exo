extends "res://Characters/Enemies/Monster.gd"

var lockTarget
var dashing = false
var canHit = true

# make the monster move
func _physics_process(delta):
	# make it rotate around and chase
	if aggro and not attacking and not dashing and canMove:
		#self.rotation = lerp_angle(self.rotation, self.global_position.angle_to_point(player.position), 0.5)
		chase(delta)
	# make it dash
	else:
		if dashing:
			set_velocity(position.direction_to(lockTarget) * speed * 4.5)
	move_and_slide()

# chases the player
func chase(delta):
	if global_position.distance_to(player.global_position) > 70:
		var new_velocity = to_local($NavigationAgent2D.get_next_path_position()).normalized() * speed
		if new_velocity.x < 0:
			$Sprite2D.flip_h = true
		elif new_velocity.x > 0:
			$Sprite2D.flip_h = false
		set_velocity(new_velocity)

	else:
		attacking = true
		set_velocity(Vector2.ZERO)
		# target PAST the player
		lockTarget = player.global_position - ((self.global_position - player.global_position) * speed * 4.5)
		if self.global_position.x - lockTarget.x > 0:
			$Sprite2D.flip_h = true
		else:
			$Sprite2D.flip_h = false
		$DamageArea.look_at(lockTarget)
		$DamageArea.visible = true
		$AttackTimer.start()

func _on_attack_timer_timeout():
	dashing = true
	$DamageArea.visible = false
	$DashTimer.start()


func _on_dash_timer_timeout():
	dashing = false
	attacking = false

func _on_damage_area_body_entered(body):
	if body.name == "Player":
			body.hit(myDmg)
