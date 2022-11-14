extends Node

# ability values stored as an array, with scale values
# - 0 ---- 1 ---- 2 ---- 3 ----- 4 -------------- 5 --------------------- 6 -------------- 7 -------- 8 -----
# name - speed - size - dmg - timeout - lifetime(after timeout) - cooldown(fire rate) - element - skill type
#                 0        1    2    3    4    5    6       7        8
var skill1 = ["fireball", 1.0, 1.0, 1.0, 1.0, 0.5, 0.5, "ignite"   , 0]
var skill2 = ["bolt",     1.1, 1.3, 0.8, 1.0, 0.5, 0.5, "shock"    , 0]
var skill3 = ["rock",     0.6, 2.0, 1.5, 0.5, 0.5, 1.0, "construct", 0]
var skill4 = ["cell",     0.4, 1.0, 1.0, 0.1, 3.0, 6.0, "growth"   , 0]
var skill5 = ["fountain", 0.0, 4.0, 2.5, 0.7, 0.7, 6.0, "flow"     , 1]

var skillArr = [skill1, skill2, skill3, skill4, skill5]

func _ready():
	pass

# returns the skill requested
func _get_ability(skill):
	return skillArr[skill]

# performs action of ability on spawn
func perform_spawn(ability):
	match ability.abilityID:
		"cell":
			var timer = Timer.new()
			timer.wait_time = 0.05
			ability.add_child(timer)
			
			timer.start()
			while true:
				print("beeg")
				ability.scale *= 1.1
				ability.dmg += 1
				yield(timer, "timeout")
				timer.start()
			
			timer.queue_free()
		"fountain":
			ability.modulate.a = 0.5
			ability.monitoring = false
		_:
			print("nothing")

# performs action of an ability on timeout
func perform_timeout(ability):
	match ability.abilityID:
		"fireball":
			print("BOOM")
		"bolt":
			print("zap")
		"rock":
			print("*falling rock noises*")
		"cell":
			print("im grass")
		"fountain":
			print("woosh")
			ability.modulate.a = 1.0
			ability.monitoring = true
		_:
			print("nothing")

# performs action of an ability before despawn
func perform_despawn(ability):
	match ability.abilityID:
		"fountain":
			var timer = Timer.new()
			timer.wait_time = 1.0
			ability.add_child(timer)
			timer.start()
			yield(timer, "timeout")
		_:
			print("simple despawn")
	ability.queue_free()
