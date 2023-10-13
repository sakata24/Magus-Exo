extends Node

var skillDict = {}

func _ready():
	var dict = {}
	var file = FileAccess.open("res://Resources/abilitysheet.txt", FileAccess.READ)
	var content = file.get_as_text()
	skillDict = JSON.parse_string(content)["skills"]
	file.close()
	pass

# returns the skill requested
func _get_ability(skill):
	return skillDict[skill]

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
				await timer.timeout
				timer.start()
			
			timer.queue_free()
		"fountain":
			ability.modulate.a = 0.5
			ability.monitoring = false
		"suspend":
			ability.modulate.a = 0.5
			var timer = Timer.new()
			timer.wait_time = 0.35
			ability.add_child(timer)
			
			timer.start()
			while true:
				print("tick")
				ability.monitoring = true
				await timer.timeout
				ability.monitoring = false
				timer.start()
			
			timer.queue_free()
			print("smoke")
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
			ability.modulate.a = 0.8
			ability.monitoring = true
		"suspend":
			print("fade")
			ability.modulate.a = 0.3
		_:
			print("nothing")

# performs action of an ability before despawn
func perform_despawn(ability):
	match ability.abilityID:
		_:
			print("simple despawn")
	ability.queue_free()
