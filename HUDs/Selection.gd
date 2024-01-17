extends CanvasLayer

var slots = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func setup():
	get_node("..").popup = true
	# loop thru card slots
	for i in range(1, 4):
		var text = ""
		# random upgrade
		var rand = randi_range(0, 11)
		match rand:
			0: text = "Increase sunder damage by 10%"
			1: text = "Sunder spells gain another cast"
			2: text = "Increase entropy projectile speed by 10%"
			3: text = "Increase entropy spell crit rate by 15%"
			4: text = "Increase construct spell size by 10%"
			5: text = "Construct spells pass through walls"
			6: text = "Increase growth spell lifetime by 10%"
			7: text = "Increase growth spell reaction potency by 10%"
			8: text = "Reduce flow spell cooldowns by 10%"
			9: text = "Flow spells gain another copy"
			10: text = "Increase wither spell lifetime by 10%"
			11: text = "Increase wither spell size by 10%"
			_: text = str(rand)
		get_node(str("HBoxContainer/Slot", i, "/VBoxContainer/Label")).text = text
		slots.push_back(rand)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_slot_1_button_pressed():
	get_node("../Player").upgrade(slots[0])
	cleanup()

func _on_slot_2_button_pressed():
	get_node("../Player").upgrade(slots[1])
	cleanup()

func _on_slot_3_button_pressed():
	get_node("../Player").upgrade(slots[2])
	cleanup()

func cleanup():
	slots = []
	self.visible = false
	get_node("..").popup = false
	get_tree().paused = false
