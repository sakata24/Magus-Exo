class_name Player extends CharacterBody2D

var dashScene = load("res://Abilities/Dash.tscn")

var remaining_casts = 0
var ability_ref = null

var damageNumber = preload("res://HUDs/DamageNumber.tscn")

@onready var focus = $ProjectilePivot/ProjectileSpawnPos

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
var cast_target = Vector2()

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
# current run data every run reinstantiated
@onready var current_run_data: PlayerRunData = PlayerRunData.new()

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
	
	if event.is_action_pressed('Q'):
		cast_ability(0)
	if event.is_action_pressed('W'):
		cast_ability(1)
	if event.is_action_pressed('E'):
		cast_ability(2)
	if event.is_action_pressed('R'):
		cast_ability(3)

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
	handle_dash_animation()
	# re-enable enemy collision
	set_collision_mask_value(4, true)

func handle_dash_animation():
	# instantiate the dash anim
	var dash_anim = dashScene.instantiate()
	# place the dash animation
	var offset = (move_target - self.global_position).normalized() * 34
	dash_anim.position = self.global_position + offset
	# aim the dash anim at the dash mouse
	dash_anim.look_at(get_global_mouse_position())
	# spawn the anim
	get_parent().add_child(dash_anim)

func _process(delta):
	process_animation()

func process_animation():
	# get current animation frames
	var frame = $AnimatedSprite2D.get_frame()
	var progress = $AnimatedSprite2D.get_frame_progress()
	# determine which type of anim
	if moving:
		$AnimatedSprite2D.set_animation("walk")
	else:
		$AnimatedSprite2D.set_animation("idle")
	# play animation
	$AnimatedSprite2D.set_frame_and_progress(frame, progress)

func _physics_process(delta):
	$ProjectilePivot.look_at(cast_target)
	emit_signal("cooling_down", skillTimer, skillCD)
	emit_signal("cooling_dash", $DashTimer.time_left, $DashTimer.wait_time)
	handle_movement(delta)
	check_and_set_skill_timers()

func check_and_set_skill_timers():
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

func handle_movement(delta):
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
	choose_sprite_direction()

func choose_sprite_direction():
	if movement.x < 0:
		$AnimatedSprite2D.flip_h = true
		$Shadow.scale.x = -1
	elif movement.x > 0:
		$AnimatedSprite2D.flip_h = false
		$Shadow.scale.x = 1

# This function handles skill casting
func cast_ability(slot_num: int):
	# check if ready
	if not skillReady[slot_num]:
		return
	# start cooldowns
	skillReady[slot_num] = false
	skillTimer[slot_num] = 0
	# obtain reference to the ability dict
	var ability_name: String = equippedSkills[slot_num]
	# cannot cast for a short period
	canCast = false
	# get cast target
	cast_target = get_global_mouse_position()
	# stop moving
	speed = 0
	moving = false
	# start a timer
	$CastTimer.start()
	await $CastTimer.timeout
	spawn_ability(ability_name)

func spawn_ability(ability_name: String):
	canCast = true
	var instantiated_ability: BaseTypeAbility = SkillSceneHandler.get_scene_by_name(ability_name)
	# spawn the projectile and initialize it
	get_parent().add_child(instantiated_ability)
	# init after creation
	instantiated_ability.init(SkillDataHandler._get_ability(ability_name), cast_target, self)
	# apply player's run buffs after creation
	apply_run_buffs(instantiated_ability)

# applys the player's run buffs
func apply_run_buffs(ability: BaseTypeAbility):
	# numbers can be handled by the spell
	current_run_data.apply_run_buffs(ability)
	# player handles multicast
	if ability.element == "sunder" and current_run_data.sunder_extra_casts > 0:
		remaining_casts = current_run_data.sunder_extra_casts
		ability_ref = ability.name
		$MultiCastTimer.start()

func _on_multi_cast_timer_timeout():
	if remaining_casts > 0:
		spawn_ability(ability_ref)
		remaining_casts -= 1
		$MultiCastTimer.start()
	else:
		ability_ref = null

func gain_xp(amount: int, elements: Array[String]):
	for element in elements:
		PersistentData.increase_xp(amount, element)

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
				if SkillDataHandler.skill_dict[equippedSkills[i]]["element"] == "flow":
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
