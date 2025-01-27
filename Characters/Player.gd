extends CharacterBody2D

class_name Player

var stormScene = preload("res://Abilities/Storm.tscn")
var crackScene = preload("res://Abilities/Crack.tscn")
var vineScene = preload("res://Abilities/Vine.tscn")
var fissureScene = preload("res://Abilities/Fissure.tscn")
var fountainScene = preload("res://Abilities/Fountain.tscn")
var suspendScene = preload("res://Abilities/Suspend.tscn")
var dashScene = preload("res://Abilities/Dash.tscn")

var boltScene = preload("res://Abilities/Bolt.tscn")
var chargeScene = preload("res://Abilities/Charge.tscn")
var rockScene = preload("res://Abilities/Rock.tscn")
var cellScene = preload("res://Abilities/Cell.tscn")

@export var sunder_dmg_boost = 1.0
@export var sunder_extra_casts = 0
var remainingCasts = 0
var skillRef = null

@export var entropy_speed_boost = 1.0
@export var entropy_crit_chance = 0.0

@export var construct_size_boost = 1.0
@export var construct_ignore_walls = false

@export var growth_lifetime_boost = 1.0
@export var growth_reaction_potency = 1.0

@export var flow_cooldown_reduction = 1.0
@export var flow_size_boost = 1.0

@export var wither_lifetime_boost = 1.0
@export var wither_size_boost = 1.0

var sunder_xp = 0
var entropy_xp = 0
var construct_xp = 0
var growth_xp = 0
var flow_xp = 0
var wither_xp = 0

var projectileLoad = preload("res://Abilities/Bullet.tscn")
var spellLoad = preload("res://Abilities/Spell.tscn")
var damageNumber = preload("res://HUDs/DamageNumber.tscn")

signal moving_to()
signal dashing_()
signal cooling_down(skill_cds, skill_cds_max)
signal cooling_dash(dash_cd, dash_cd_max)
signal player_hit(newHP, maxHP)

# instance variable for player HP
var health = 25
var maxHealth = 25

# instance variables for player movement
var max_speed = 100
var speed = 0
var moving = false
var dashing = false
var move_dir
var move_target = Vector2()
var movement = Vector2()
var castTarget = Vector2()

# instance variables for XP handling
var lvl = 0
var xp = 0

# to be changed when the player obtains a new skill
var upgradesChosen = []

# to be changed when the player equips different skills
var equippedSkills = ["bolt", "charge", "rock", "fountain"]

# player's unlocked skills
var unlockedSkills = ["bolt", "charge", "rock", "fountain", "vine", "suspend"]

var skillReady = [true, true, true, true]
# the amt of physics processes to occur before ability to use the skill again
var skillCD = [0, 0, 0, 0]
# the current amt of physics processes that ran since last using the skill
var skillTimer = [10, 10, 10, 10]
# the dash cd
var dashCD = 4
# can dash
var canDash = true
# the dash ready
var dashIFrames = 0
# can cast an ability
var canCast = true

func _ready():
	sunder_xp = get_node("/root/CustomResourceLoader").sunder_xp
	entropy_xp = get_node("/root/CustomResourceLoader").entropy_xp
	construct_xp = get_node("/root/CustomResourceLoader").construct_xp
	growth_xp = get_node("/root/CustomResourceLoader").growth_xp
	flow_xp = get_node("/root/CustomResourceLoader").flow_xp
	wither_xp = get_node("/root/CustomResourceLoader").wither_xp
	$DashTimer.wait_time = dashCD
	move_target = Vector2(self.position.x, 10000.0)
	initSkills()

func initSkills():
	skillCD[0] = SkillDataHandler.skillDict[equippedSkills[0]]["cooldown"] * 10
	skillCD[1] = SkillDataHandler.skillDict[equippedSkills[1]]["cooldown"] * 10
	skillCD[2] = SkillDataHandler.skillDict[equippedSkills[2]]["cooldown"] * 10
	skillCD[3] = SkillDataHandler.skillDict[equippedSkills[3]]["cooldown"] * 10
	skillTimer[0] = skillCD[0]
	skillTimer[1] = skillCD[1]
	skillTimer[2] = skillCD[2]
	skillTimer[3] = skillCD[3]

func get_unlocked_skills():
	return unlockedSkills

func get_equipped_skills():
	return equippedSkills

# handles right clicks
func _unhandled_input(event):
	if event.is_action_pressed('R-Click'):
		moving = true
		move_target = get_global_mouse_position()
		emit_signal("moving_to")
	
	if event.is_action_pressed('Space') and canDash:
		set_collision_mask_value(4, false)
		#set_collision_layer_value(1, false)
		#set_collision_layer_value(4, false)
		$DashTimer.start()
		dashing = true
		move_target = get_global_mouse_position()
		var dashAnim = dashScene.instantiate()
		var offset = (move_target - self.global_position).normalized() * 34
		dashAnim.position = self.global_position + offset
		dashAnim.look_at(get_global_mouse_position())
		get_parent().add_child(dashAnim)
		await get_tree().create_timer(0.1).timeout
		set_collision_mask_value(4, true)
		#set_collision_layer_value(4, true)
		#set_collision_layer_value(1, true)
	
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
			_: projectile = crackScene.instantiate()
		# spawn the projectile and initialize it
		get_parent().add_child(projectile)
		projectile.position = $ProjectilePivot/ProjectileSpawnPos.global_position
		projectile.init(ability, castTarget, self)
		# calculates the projectiles direction
		projectile.velocity = (castTarget - projectile.position).normalized()
		if construct_ignore_walls and projectile.element == "construct":
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
	if ability["element"] == "sunder" and sunder_extra_casts > 0:
		remainingCasts = sunder_extra_casts
		skillRef = skill
		$MultiCastTimer.start()

func _on_multi_cast_timer_timeout():
	if remainingCasts > 0:
		var ability = SkillDataHandler._get_ability(skillRef)
		if ability["type"] == "bullet":
			# load the projectile
			var projectile = projectileLoad.instantiate()
			# spawn the projectile and initialize it
			get_parent().add_child(projectile)
			projectile.position = $ProjectilePivot/ProjectileSpawnPos.global_position
			projectile.init(ability, castTarget, self)
			# calculates the projectiles direction
			projectile.velocity = (castTarget - projectile.position).normalized()
		elif ability["type"] == "spell":
			# load the spell
			var spell = spellLoad.instantiate()
			# spawn the spell and initialize it
			get_parent().add_child(spell)
			spell.init(ability, castTarget, self)
		remainingCasts -= 1
		$MultiCastTimer.start()
	else:
		skillRef = null


func gain_xp(amount, elements):
	print("i ran")
	for element in elements:
		match element:
			"sunder": sunder_xp += amount
			"entropy": entropy_xp += amount
			"construct": construct_xp += amount
			"growth": growth_xp += amount
			"flow": flow_xp += amount
			"wither": wither_xp += amount

func hit(damage):
	health -= damage
	emit_signal("player_hit", health, maxHealth)
	var dmgNum = damageNumber.instantiate()
	dmgNum.modulate = Color(255, 0, 0)
	get_parent().add_child(dmgNum)
	dmgNum.set_value_and_pos(damage, self.global_position)

func _on_dash_timer_timeout():
	canDash = true

func upgrade(upgrade_int):
	match upgrade_int:
		0: sunder_dmg_boost += 0.1
		1: sunder_extra_casts += 1
		2: entropy_speed_boost += 0.1
		3: entropy_crit_chance += 0.15
		4: construct_size_boost += 0.1
		5: construct_ignore_walls = true
		6: growth_lifetime_boost += 0.1
		7: growth_reaction_potency += 0.1
		8: 
			flow_cooldown_reduction *= 0.9
			for i in range(0, 4):
				if SkillDataHandler.skillDict[equippedSkills[i]]["element"] == "flow":
					skillCD[i] *= flow_cooldown_reduction
					skillTimer[i] = skillCD[i]
		9: flow_size_boost += 0.1
		10: wither_lifetime_boost += 0.1
		11: wither_size_boost += 0.1
		_: pass
	print("upgraded: ", upgrade_int)

func save():
	var save_skills = []
	for e in unlockedSkills:
		save_skills.append({"name": e})
	var save_dict = {
		"sunder_xp": sunder_xp,
		"entropy_xp": entropy_xp,
		"construct_xp": construct_xp,
		"growth_xp": growth_xp,
		"flow_xp": flow_xp,
		"wither_xp": wither_xp,
		"skills": save_skills
	}
	print(save_dict)
	return save_dict

func spawn_light():
	var light = $PointLight2D
	light.scale = Vector2(20,20)
	light.visible = true
	var tween = create_tween()
	tween.tween_property(light, "scale", Vector2(1.5,1.5), 2)
	await tween.finished
	return true
