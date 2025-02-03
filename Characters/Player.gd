class_name Player extends CharacterBody2D

var stormScene = preload("res://Abilities/Storm.tscn")
var crackScene = preload("res://Abilities/Crack.tscn")
var vineScene = preload("res://Abilities/Vine.tscn")
var fissureScene = preload("res://Abilities/Fissure.tscn")
var fountainScene = preload("res://Abilities/Fountain.tscn")
var suspendScene = preload("res://Abilities/Suspend.tscn")

var boltScene = preload("res://Abilities/Bolt.tscn")
var chargeScene = preload("res://Abilities/Charge.tscn")
var rockScene = preload("res://Abilities/Rock.tscn")
var cellScene = preload("res://Abilities/Cell.tscn")
var displaceScene = preload("res://Abilities/Displace.tscn")
var decayScene = preload("res://Abilities/Decay.tscn")

var dashScene = preload("res://Abilities/Dash.tscn")

@onready var current_run_data = preload("res://Characters/RunData.gd").new()

var remaining_casts = 0
var skill_ref = null

var damageNumber = preload("res://HUDs/DamageNumber.tscn")

signal moving_to()
signal dashing_()
signal cooling_down(skill_cds, skill_cds_max)
signal cooling_dash(dash_cd, dash_cd_max)
signal player_hit(newHP, maxHP)

# instance variables for player HP
var health = 25
var max_health = 25

# instance variables for player movement
var max_speed = 100
var speed = 0
var moving = false
var dashing = false
var move_dir
var move_target = Vector2()
var movement = Vector2()
var castTarget = Vector2()

# to be changed when the player obtains a new skill
var upgradesChosen = []

# to be changed when the player equips different skills
var equippedSkills = ["bolt", "charge", "rock", "fountain"]

var skillReady = [true, true, true, true]
# the amt of physics processes to occur before ability to use the skill again
var skillCD = [0, 0, 0, 0]
# the current amt of physics processes that ran since last using the skill
var skillTimer = [10, 10, 10, 10]
# can dash
var canDash = true
# the dash ready
var dashIFrames = 0
# can cast an ability
var canCast = true

# on ready
func _ready():
	# Make the player look right
	move_target = Vector2(self.position.x, 10000.0)
	init_skill_cooldowns()
	
func init_skill_cooldowns():
	# set the cooldowns
	skillCD[0] = SkillDataHandler.skill_dict[equippedSkills[0]]["cooldown"] * 10
	skillCD[1] = SkillDataHandler.skill_dict[equippedSkills[1]]["cooldown"] * 10
	skillCD[2] = SkillDataHandler.skill_dict[equippedSkills[2]]["cooldown"] * 10
	skillCD[3] = SkillDataHandler.skill_dict[equippedSkills[3]]["cooldown"] * 10
	# set the timers that count the cooldown
	skillTimer[0] = skillCD[0]
	skillTimer[1] = skillCD[1]
	skillTimer[2] = skillCD[2]
	skillTimer[3] = skillCD[3]

func get_unlocked_skills():
	return PersistentData.get_unlocked_skills()

func get_equipped_skills():
	return equippedSkills

# handles all inputs
func _unhandled_input(event):
	if event.is_action_pressed('R-Click'):
		handle_move_event()
	
	if event.is_action_pressed('Space') and canDash:
		handle_dash_event()
	
	if event.is_action_pressed('Q') and skillReady[0]:
		cast_ability(equippedSkills[0])
		skillReady[0] = false
		skillTimer[0] = 0
			
	if event.is_action_pressed('W') and skillReady[1]:
		cast_ability(equippedSkills[1])
		skillReady[1] = false
		skillTimer[1] = 0
			
	if event.is_action_pressed('E') and skillReady[2]:
		cast_ability(equippedSkills[2])
		skillReady[2] = false
		skillTimer[2] = 0
			
	if event.is_action_pressed('R') and skillReady[3]:
		cast_ability(equippedSkills[3])
		skillReady[3] = false
		skillTimer[3] = 0

func handle_move_event():
	moving = true
	move_target = get_global_mouse_position()
	emit_signal("moving_to")

func handle_dash_event():
	# disable enemy collision
	set_collision_mask_value(4, false)
	# start the cooldown
	$DashTimer.start()
	# toggle the dash variable
	dashing = true
	# execute the dash
	move_target = get_global_mouse_position()
	# instantiate the dash
	var dashAnim = dashScene.instantiate()
	# place the dash animation
	var offset = (move_target - self.global_position).normalized() * 34
	dashAnim.position = self.global_position + offset
	# aim the dash anim at the dash mouse
	dashAnim.look_at(get_global_mouse_position())
	# spawn the anim
	get_parent().add_child(dashAnim)
	# re-enable enemy collision
	set_collision_mask_value(4, true)

func _process(delta):
	if moving:
		var frame = $AnimatedSprite2D.get_frame()
		var progress = $AnimatedSprite2D.get_frame_progress()
		$AnimatedSprite2D.set_animation("walk")
		$AnimatedSprite2D.set_frame_and_progress(frame, progress)
	else:
		var frame = $AnimatedSprite2D.get_frame()
		var progress = $AnimatedSprite2D.get_frame_progress()
		$AnimatedSprite2D.set_animation("idle")
		$AnimatedSprite2D.set_frame_and_progress(frame, progress)

func _physics_process(delta):
	$ProjectilePivot.look_at(castTarget)
	emit_signal("cooling_down", skillTimer, skillCD)
	emit_signal("cooling_dash", $DashTimer.time_left, $DashTimer.wait_time)
	movementHelper(delta)
	if skillTimer[0] >= skillCD[0]:
		skillReady[0] = true
	else:
		skillTimer[0] += 1
		
	if skillTimer[1] >= skillCD[1]:
		skillReady[1] = true
	else:
		skillTimer[1] += 1
		
	if skillTimer[2] >= skillCD[2]:
		skillReady[2] = true
	else:
		skillTimer[2] += 1
		
	if skillTimer[3] >= skillCD[3]:
		skillReady[3] = true
	else:
		skillTimer[3] += 1

func movementHelper(delta):
	
	if dashing and canDash:
		var offset = (move_target - self.global_position).normalized() * 58
		move_and_collide(offset)
		dashing = false
		canDash = false
	# if moving continue, if not stop moving
	elif not moving:
		speed = 0
	else:
		speed = max_speed
	
	# calculates movement and direction
	movement = position.direction_to(move_target) * speed
	move_dir = rad_to_deg(move_target.angle_to_point(position))
	
	# do we need to move more or not
	if position.distance_to(move_target) > 1:
		set_velocity(movement)
		move_and_slide()
		movement = velocity
	else:
		moving = false
	if movement.x < 0:
		$AnimatedSprite2D.flip_h = true
		$Shadow.scale.x = -1
	elif movement.x > 0:
		$AnimatedSprite2D.flip_h = false
		$Shadow.scale.x = 1

# This function handles skill casting
func cast_ability(skill):
	# obtain reference to the ability dict
	var ability = SkillDataHandler._get_ability(skill)
	canCast = false
	castTarget = get_global_mouse_position()
	speed = 0
	moving = false
	$CastTimer.start()
	await $CastTimer.timeout
	canCast = true
	if ability["type"] == "bullet":
		# load the projectile
		var projectile
		match skill:
			"bolt": projectile = boltScene.instantiate()
			"charge": projectile = chargeScene.instantiate()
			"rock": projectile = rockScene.instantiate()
			"cell": projectile = cellScene.instantiate()
			"displace": projectile = displaceScene.instantiate()
			"decay": projectile = decayScene.instantiate()
			_: projectile = crackScene.instantiate()
		# spawn the projectile and initialize it
		get_parent().add_child(projectile)
		projectile.position = $ProjectilePivot/ProjectileSpawnPos.global_position
		projectile.init(ability, castTarget, self)
		# calculates the projectiles direction
		projectile.velocity = (castTarget - projectile.position).normalized()
		if current_run_data.construct_ignore_walls and current_run_data.projectile.element == "construct":
			projectile.set_collision_mask_value(6, false)
	elif ability["type"] == "spell":
		var spell
		match skill:
			"crack": spell = crackScene.instantiate()
			"storm": spell = stormScene.instantiate()
			"fissure": spell = fissureScene.instantiate()
			"vine": spell = vineScene.instantiate()
			"fountain": spell = fountainScene.instantiate()
			"suspend": spell = suspendScene.instantiate()
			_: crackScene.instantiate()
		# spawn the spell and initialize it
		get_parent().add_child(spell)
		spell.init(ability, castTarget, self)
	if ability["element"] == "sunder" and current_run_data.sunder_extra_casts > 0:
		remaining_casts = current_run_data.sunder_extra_casts
		skill_ref = skill
		$MultiCastTimer.start()

func _on_multi_cast_timer_timeout():
	if remaining_casts > 0:
		var ability = SkillDataHandler._get_ability(skill_ref)
		if ability["type"] == "bullet":
			# load the projectile
			var projectile = boltScene.instantiate()
			# spawn the projectile and initialize it
			get_parent().add_child(projectile)
			projectile.position = $ProjectilePivot/ProjectileSpawnPos.global_position
			projectile.init(ability, castTarget, self)
			# calculates the projectiles direction
			projectile.velocity = (castTarget - projectile.position).normalized()
		elif ability["type"] == "spell":
			# load the spell
			var spell = crackScene.instantiate()
			# spawn the spell and initialize it
			get_parent().add_child(spell)
			spell.init(ability, castTarget, self)
		remaining_casts -= 1
		$MultiCastTimer.start()
	else:
		skill_ref = null


func gain_xp(amount, elements):
	print("i ran")
	for element in elements:
		match element:
			"sunder": PersistentData.sunder_xp += amount
			"entropy": PersistentData.entropy_xp += amount
			"construct": PersistentData.construct_xp += amount
			"growth": PersistentData.growth_xp += amount
			"flow": PersistentData.flow_xp += amount
			"wither": PersistentData.wither_xp += amount

func hit(damage):
	health -= damage
	emit_signal("player_hit", health, max_health)
	var dmgNum = damageNumber.instantiate()
	dmgNum.modulate = Color(255, 0, 0)
	get_parent().add_child(dmgNum)
	dmgNum.set_value_and_pos(damage, self.global_position)

func _on_dash_timer_timeout():
	canDash = true

func upgrade(upgrade_int):
	match upgrade_int:
		0: current_run_data.sunder_dmg_boost += 0.1
		1: current_run_data.sunder_extra_casts += 1
		2: current_run_data.entropy_speed_boost += 0.1
		3: current_run_data.entropy_crit_chance += 0.15
		4: current_run_data.construct_size_boost += 0.1
		5: current_run_data.construct_ignore_walls = true
		6: current_run_data.growth_lifetime_boost += 0.1
		7: current_run_data.growth_reaction_potency += 0.1
		8: 
			current_run_data.flow_cooldown_reduction *= 0.9
			for i in range(0, 4):
				if SkillDataHandler.skillDict[equippedSkills[i]]["element"] == "flow":
					skillCD[i] *= current_run_data.flow_cooldown_reduction
					skillTimer[i] = skillCD[i]
		9: current_run_data.flow_size_boost += 0.1
		10: current_run_data.wither_lifetime_boost += 0.1
		11: current_run_data.wither_size_boost += 0.1
		_: pass
	print("upgraded: ", upgrade_int)

func spawn_light():
	var light = $PointLight2D
	light.scale = Vector2(20,20)
	light.visible = true
	var tween = create_tween()
	tween.tween_property(light, "scale", Vector2(1.5,1.5), 2)
	await tween.finished
	return true
