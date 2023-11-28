extends CharacterBody2D

class_name Player

var projectileLoad = preload("res://Abilities/Bullet.tscn")
var spellLoad = preload("res://Abilities/Spell.tscn")

signal gained_xp(curr_xp, xp_threshold)
signal level_up(level)
signal moving_to()
signal dashing_()
signal cooling_down(skill_cds, skill_cds_max)

# constants
const XPTHRESHOLDS = [5, 10, 15, 20]

# instance variable for player HP
var health = 25

# instance variables for player movement
var max_speed = 100
var speed = 0
var moving = false
var dashing = false
var move_dir
var move_target = Vector2()
var movement = Vector2()

# instance variables for XP handling
var currentXpThreshold = XPTHRESHOLDS[0]
var lvl = 0
var xp = 0

# to be changed when the player obtains a new skill
var learnedSkills = [0, 1, 2, 3, 4, 5]

# to be changed when the player equips different skills
var equippedSkills = ["bolt", "rock", "fountain", "suspend"]

var skillReady = [true, true, true, true]
# the amt of physics processes to occur before ability to use the skill again
var skillCD = [10, 10, 10, 10]
# the current amt of physics processes that ran since last using the skill
var skillTimer = [10, 10, 10, 10]
# the dash cd
var dashCD = 4
# can dash
var canDash = true
# the dash ready
var dashIFrames = 0

func _ready():
	$DashTimer.wait_time = dashCD
	initSkills()

func initSkills():
	skillCD[0] *= UniversalSkills.skillDict[equippedSkills[0]]["cooldown"]
	skillCD[1] *= UniversalSkills.skillDict[equippedSkills[1]]["cooldown"]
	skillCD[2] *= UniversalSkills.skillDict[equippedSkills[2]]["cooldown"]
	skillCD[3] *= UniversalSkills.skillDict[equippedSkills[3]]["cooldown"]
	skillTimer[0] = skillCD[0]
	skillTimer[1] = skillCD[1]
	skillTimer[2] = skillCD[2]
	skillTimer[3] = skillCD[3]

# handles right clicks
func _unhandled_input(event):
	if event.is_action_pressed('R-Click'):
		moving = true
		move_target = get_global_mouse_position()
		emit_signal("moving_to")
	
	if event.is_action_pressed('Space') and canDash:
		dashing = true
		move_target = get_global_mouse_position()
	
	if event.is_action_pressed('Q'):
		if skillReady[0]:
			cast_ability(equippedSkills[0])
			skillReady[0] = false
			skillTimer[0] = 0
			
	if event.is_action_pressed('W'):
		if skillReady[1]:
			cast_ability(equippedSkills[1])
			skillReady[1] = false
			skillTimer[1] = 0
			
	if event.is_action_pressed('E'):
		if skillReady[2]:
			cast_ability(equippedSkills[2])
			skillReady[2] = false
			skillTimer[2] = 0
			
	if event.is_action_pressed('R'):
		if skillReady[3]:
			cast_ability(equippedSkills[3])
			skillReady[3] = false
			skillTimer[3] = 0
			
			
func _process(delta):
	pass

func _physics_process(delta):
	$ProjectilePivot.look_at(get_global_mouse_position())
	emit_signal("cooling_down", skillTimer, skillCD)
	movementHelper(delta)
	if skillTimer[0] == skillCD[0]:
		skillReady[0] = true
	else:
		skillTimer[0] += 1
		
	if skillTimer[1] == skillCD[1]:
		skillReady[1] = true
	else:
		skillTimer[1] += 1
		
	if skillTimer[2] == skillCD[2]:
		skillReady[2] = true
	else:
		skillTimer[2] += 1
		
	if skillTimer[3] == skillCD[3]:
		skillReady[3] = true
	else:
		skillTimer[3] += 1

func movementHelper(delta):
	
	if dashing and canDash:
		print("debug")
		get_node("CollisionShape2D").disabled = true
		speed = max_speed * 11
		dashIFrames += 1
		$DashTimer.start()
		if dashIFrames >= 3:
			dashIFrames = 0
			dashing = false
			canDash = false
			get_node("CollisionShape2D").disabled = false
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

# This function handles skill casting
func cast_ability(skill):
	# obtain reference to the ability dict
	var ability = UniversalSkills._get_ability(skill)
	
	if ability["type"] == "bullet":
		# load the projectile
		var projectile = projectileLoad.instantiate()
		# spawn the projectile and initialize it
		get_parent().add_child(projectile)
		projectile.position = $ProjectilePivot/ProjectileSpawnPos.global_position
		projectile.init(ability)
		# calculates the projectiles direction
		projectile.velocity = get_global_mouse_position() - projectile.position
	elif ability["type"] == "spell":
		# load the spell
		var spell = spellLoad.instantiate()
		# spawn the spell and initialize it
		get_parent().add_child(spell)
		spell.init(ability, get_global_mouse_position())

func gain_xp(amount):
	xp += amount
	if xp >= currentXpThreshold:
		print("level up!")
		lvl += 1
		emit_signal("level_up", lvl)
		# increment currentXpThreshold to the next
		currentXpThreshold = XPTHRESHOLDS[XPTHRESHOLDS.find(currentXpThreshold) + 1]
	print("gained ", amount, " xp")
	emit_signal("gained_xp", xp, currentXpThreshold)

func hit(damage):
	health -= damage

func _on_dash_timer_timeout():
	canDash = true
