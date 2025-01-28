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
@export var health = 100
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
@export var can_move = true
# can i drop upgrades
var droppable = true
# last damage hit with
var lastElementsHitBy = []

signal give_xp(xp, elements)

func _ready():
	pass

func init():
	pass

# handle internal processes
func _process(delta):
	if !can_move:
		$StatusLabel.visible = true
	else:
		$StatusLabel.visible = false
	if health <= 0:
		die()

# make the monster move
func _physics_process(delta):
	if aggro and not attacking and can_move:
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
func _hit(dmg_to_take, dmg_type_1, dmg_type_2, caster):
	# reduce my hp
	health -= dmg_to_take
	# set the element to give player xp for
	if dmg_type_1 == dmg_type_2:
		lastElementsHitBy = [dmg_type_1]
	else:
		lastElementsHitBy = [dmg_type_1, dmg_type_2]
	## create the dmg numbers ##
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
	# aggro on the caster
	if caster and caster.name == "Player":
		aggro = true
		player = caster
		$PathTimer.start()

# when player makes me mad
func _on_AggroRange_body_entered(body: CharacterBody2D):
	if body:
		if body.name == "Player":
			aggro = true
			player = body
			$PathTimer.start()

# when i die
func die():
	if droppable:
		var drop
		match randi_range(0, 2):
			0: 
				drop = upgradeDrop.instantiate()
			_:
				drop = null
		if drop != null:
			drop.position = position
			get_parent().add_child(drop)
	# give the player xp
	emit_signal("give_xp", bestowedXp, lastElementsHitBy)
	queue_free()

func _on_attack_timer_timeout():
	for body in $DamageArea.get_overlapping_bodies():
		if body.name == "Player":
			body.hit(myDmg)
	attacking = false
	$DamageArea/Indicator.visible = false

func _on_path_timer_timeout():
	$NavigationAgent2D.target_position = player.global_position
