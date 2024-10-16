class_name Monster extends CharacterBody2D

var damageNumber = preload("res://HUDs/DamageNumber.tscn")
var upgradeDrop = preload("res://Interactables/UpgradeChest.tscn")

# am i mad
var aggro = false
# reference to chase the player
var player = CharacterBody2D
# how fast i move
var speed = 50
# base speed for ref
var baseSpeed = 50
# my health
var health = 100
# damage
var myDmg = 2
# base dmg for ref
var baseDmg = 2
# max health
var maxHealth = 100
# exp i give
var bestowedXp = 1
# am i attacking
var attacking = false
# can i move
var canMove = true
# can i drop upgrades
var droppable = true

signal giveXp(xp)

func _ready():
	pass

func init():
	pass

# handle internal processes
func _process(delta):
	if !canMove:
		$StatusLabel.visible = true
	else:
		$StatusLabel.visible = false
	if health <= 0:
		die()

# make the monster move
func _physics_process(delta):
	if aggro and not attacking and canMove:
		#self.rotation = lerp_angle(self.rotation, self.global_position.angle_to_point(player.position), 0.1)
		chase(delta)
	move_and_slide()

# chases the player
func chase(delta):
	if global_position.distance_to(player.global_position) > 19:
		var new_velocity = to_local($NavigationAgent2D.get_next_path_position()).normalized() * speed
		if new_velocity.x < 0:
			$Sprite2D.flip_h = true
		elif new_velocity.x > 0:
			$Sprite2D.flip_h = false
		set_velocity(new_velocity)
		
	else:
		set_velocity(Vector2.ZERO)
		attacking = true
		$DamageArea/Indicator.visible = true
		$DamageArea.look_at(player.position)
		$AttackTimer.start()

# hit by something
func _hit(dmg_to_take, dmg_color):
	health -= dmg_to_take
	#print("i took ", dmg_to_take, " dmg")
	var dmgNum = damageNumber.instantiate()
	dmgNum.modulate = dmg_color
	get_parent().add_child(dmgNum)
	dmgNum.set_value_and_pos(self.global_position, dmg_to_take)
	

# when player makes me mad
func _on_AggroRange_body_entered(body: CharacterBody2D):
	if body:
		if body.name == "Player":
			aggro = true
			player = body
			$PathTimer.start()

# when i die
func die():
	emit_signal("giveXp", bestowedXp)
	if droppable:
		var drop
		match randi_range(0, 2):
			0: 
				print("pee")
				drop = upgradeDrop.instantiate()
			_:
				drop = null
		if drop != null:
			drop.position = position
			get_parent().add_child(drop)
	queue_free()

func _on_attack_timer_timeout():
	for body in $DamageArea.get_overlapping_bodies():
		if body.name == "Player":
			body.hit(myDmg)
	attacking = false
	$DamageArea/Indicator.visible = false

func _on_path_timer_timeout():
	$NavigationAgent2D.target_position = player.global_position
