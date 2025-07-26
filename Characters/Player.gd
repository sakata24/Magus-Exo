class_name Player extends CharacterBody2D

var dashScene = load("res://Abilities/Dash.tscn")

var remaining_casts: int = -1
var ability_ref: String = ""

var damageNumber = preload("res://HUDs/DamageNumber.tscn")
var popup_text = preload("res://HUDs/PopupText.tscn")
var cast_audio = preload("res://Resources/audio/sfx/cast.ogg")

@onready var focus: Marker2D = $ProjectilePivot/ProjectileSpawnPos
@onready var my_cam: PlayerCamera = get_node("Camera2D")

signal moving_to()
signal dashing_()
signal cooling_down(skill_cds, skill_cds_max)
signal cooling_dash(dash_cd, dash_cd_max)
signal health_changed(newHP, maxHP)
signal player_died

# instance variables for player HP
var health: int = 15
var max_health: int = 15

# instance variables for player movement
var max_speed: int = 130
var speed: int = 0
var moving: bool = false
var dashing: bool = false
var move_dir
var move_target: Vector2 = Vector2()
var movement: Vector2 = Vector2()
var cast_target: Vector2 = Vector2()

# to be changed when the player obtains a new skill
var upgradesChosen: Array = []

# to be changed when the player equips different skills
var equippedSkills: Array = ["bolt", "charge", "rock", "fountain"]

var skillReady: Array[bool] = [true, true, true, true]
# the amt of physics processes to occur before ability to use the skill again
var skillCD: Array[float] = [0, 0, 0, 0]
# the current amt of physics processes that ran since last using the skill
var skillTimer: Array[float] = [10, 10, 10, 10]
# can dash
var canDash: bool = true
# the dash iframes
var dashIFrames: int = 0
# can cast an ability
var canCast: bool = true
# is casting
var casting: bool = false
# current run data every run reinstantiated
@onready var current_run_data: PlayerRunData = PlayerRunData.new()

# on ready
func _ready():
	$MultiplayerSynchronizer.set_multiplayer_authority(str(name).to_int())
	# Update the equipped skills
	equippedSkills = PersistentData.get_equipped_skills()
	# Make the player look right
	move_target = Vector2(self.position.x, 10000.0)
	self.add_to_group("players")
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

func set_equipped_skills(new_skills: Array):
	equippedSkills = new_skills
	init_skill_cooldowns()

func _physics_process(delta):
	$ProjectilePivot.look_at(cast_target)
	emit_signal("cooling_down", skillTimer, skillCD)
	emit_signal("cooling_dash", get_node("DashTimer").time_left, get_node("DashTimer").wait_time)
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

func choose_sprite_direction():
	if movement.x < 0:
		$AnimatedSprite2D.flip_h = true
		$Shadow.scale.x = -1
	elif movement.x > 0:
		$AnimatedSprite2D.flip_h = false
		$Shadow.scale.x = 1

# This function handles skill casting
func cast_ability(slot_num: int) -> bool:
	if multiplayer.get_unique_id() == self.name.to_int():
		# check if ready
		if (not skillReady[slot_num]) or (not $CastTimer.is_stopped()):
			return false
		# casting
		casting = true
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
		# play sound
		play_cast_sound()
		# start a timer
		$CastTimer.start()
		await $CastTimer.timeout
		canCast = true
		spawn_ability.rpc(ability_name, cast_target)
		return true
	else:
		return false

func play_cast_sound():
	# play casting audio
	$AudioStreamPlayer2D.set_stream(cast_audio)
	$AudioStreamPlayer2D.pitch_scale = randf_range(0.85, 1.15)
	$AudioStreamPlayer2D.play()

@rpc("any_peer", "call_local", "unreliable_ordered")
func spawn_ability(ability_name: String, my_cast_target: Vector2):
	if !multiplayer.is_server():
		return
	canCast = true
	var instantiated_ability: BaseTypeAbility = SkillSceneHandler.get_scene_by_name(ability_name).instantiate()
	# init after creation
	instantiated_ability.init(SkillDataHandler._get_ability(ability_name), my_cast_target, self)
	# spawn the projectile and initialize it
	get_parent().add_child(instantiated_ability, true)
	# apply player's run buffs after creation
	apply_run_buffs(instantiated_ability)

# applys the player's run buffs
func apply_run_buffs(ability: BaseTypeAbility):
	# numbers can be handled by the spell
	current_run_data.apply_run_buffs(ability)
	# player handles multicast
	if ability.element == "sunder" and current_run_data.sunder_extra_casts > 0 and remaining_casts == -1:
		remaining_casts = current_run_data.sunder_extra_casts 
		ability_ref = ability.abilityID
		$MultiCastTimer.start()

func _on_multi_cast_timer_timeout():
	if remaining_casts > 0 and ability_ref:
		remaining_casts -= 1
		spawn_ability(ability_ref, cast_target)
		$MultiCastTimer.start()
	else:
		remaining_casts = -1
		ability_ref =""

func gain_xp(amount: int, elements: Array[String]):
	for element in elements:
		PersistentData.increase_xp(amount, element)

func hit(damage: DamageObject):
	health -= damage.get_value()
	if health < 0:
		health = 0
	emit_signal("health_changed", health, max_health)
	var dmgNum = damageNumber.instantiate()
	dmgNum.modulate = Color(255, 0, 0)
	get_parent().add_child(dmgNum)
	dmgNum.set_value_and_pos(damage.get_value(), self.global_position)

func heal(amount: int):
	health += amount
	if health > max_health:
		health = max_health
	emit_signal("health_changed", health, max_health)
	var heal_num = damageNumber.instantiate()
	heal_num.modulate = Color(0, 255, 0)
	get_parent().add_child(heal_num)
	heal_num.set_value_and_pos(amount, self.global_position)

func upgrade(upgrade_name):
	match upgrade_name:
		"sunder_dmg": current_run_data.sunder_dmg_boost += 0.1
		"sunder_multicast": current_run_data.sunder_extra_casts += 1
		"entropy_spd": current_run_data.entropy_speed_boost += 0.1
		"entropy_cr": current_run_data.entropy_crit_chance += 0.15
		"construct_size": current_run_data.construct_size_boost += 0.1
		"construct_passthru": current_run_data.construct_ignore_walls = true
		"growth_lifetime": current_run_data.growth_lifetime_boost += 0.1
		"growth_rpotency": current_run_data.growth_reaction_potency += 0.1
		"flow_cd": 
			current_run_data.flow_cooldown_reduction *= 0.9
			for i in range(0, 4):
				if SkillDataHandler.skill_dict[equippedSkills[i]]["element"] == "flow":
					skillCD[i] *= current_run_data.flow_cooldown_reduction
					skillTimer[i] = skillCD[i]
		"flow_size": current_run_data.flow_size_boost += 0.1
		"wither_lifetime": current_run_data.wither_lifetime_boost += 0.1
		"wither_size": current_run_data.wither_size_boost += 0.1
		_: pass
	if current_run_data.obtained_buffs.has(upgrade_name):
		current_run_data.obtained_buffs[upgrade_name] += 1
	else:
		current_run_data.obtained_buffs[upgrade_name] = 1
	#print("upgraded: ", upgrade_name)

func spawn_light(seconds: float):
	var light = $PointLight2D
	light.scale = Vector2(20,20)
	light.visible = true
	light.energy = 0.0
	var tween = create_tween()
	tween.tween_property(light, "scale", Vector2(2.0,2.0), seconds)
	tween.parallel().tween_property(light, "energy", 1.0, seconds)
	await tween.finished
	return true

func despawn_light(seconds: float):
	var light = $PointLight2D
	var tween = create_tween()
	tween.tween_property(light, "modulate", Color(1,1,1,0), seconds)
	tween.parallel().tween_property(light, "energy", 0.0, seconds)
	tween.play()
	await tween.finished
	light.visible = false
	light.modulate = Color(1,1,1,1)

func shake():
	my_cam.apply_shake()
