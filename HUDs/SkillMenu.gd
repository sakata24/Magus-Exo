extends CanvasLayer

var dict


# Called when the node enters the scene tree for the first time.
func _ready():
	var file = FileAccess.open("res://Resources/abilitysheet.txt", FileAccess.READ)
	dict = UniversalSkills.get_skills()
	print_dictionary()
	file.close()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass





func print_dictionary():
	for n in dict:
		print(UniversalSkills._get_ability(n))
