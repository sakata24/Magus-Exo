extends CanvasLayer

var slots = []

const ART_PATH = "res://Resources/hud_elements/"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func setup():
	get_tree().paused = true
	get_parent()._add_menu(self)
	# loop thru card slots
	for i in range(1, 4):
		var text = ""
		var element = ""
		# random upgrade
		var rand = randi_range(0, 11)
		match rand:
			0: 
				text = "Increase sunder damage by 10%"
				element = "sunder"
			1: 
				text = "Sunder spells gain another cast"
				element = "sunder"
			2: 
				text = "Increase entropy projectile speed by 10%"
				element = "entropy"
			3: 
				text = "Increase entropy spell crit rate by 15%"
				element = "entropy"
			4: 
				text = "Increase construct spell size by 10%"
				element = "construct"
			5: 
				text = "Construct spells pass through walls"
				element = "construct"
			6: 
				text = "Increase growth spell lifetime by 10%"
				element = "growth"
			7: 
				text = "Increase growth spell reaction potency by 10%"
				element = "growth"
			8: 
				text = "Reduce flow spell cooldowns by 10%"
				element = "flow"
			9: 
				text = "Increase flow spell size by 10%"
				element = "flow"
			10: 
				text = "Increase wither spell lifetime by 10%"
				element = "wither"
			11: 
				text = "Increase wither spell size by 10%"
				element = "wither"
			_: 
				text = str(rand)
				element = "sunder"
		get_node(str("HBoxContainer/Slot", i, "/VBoxContainer/Label")).text = text
		get_node(str("HBoxContainer/Slot", i, "/VBoxContainer/TextureRect")).texture = load(ART_PATH+element+"-card-sprite"+".png")
		if !get_node(str("HBoxContainer/Slot", i, "/VBoxContainer/TextureRect")).texture:
			get_node(str("HBoxContainer/Slot", i, "/VBoxContainer/TextureRect")).texture = load("res://Resources/icon.png")
		slots.push_back(rand)
		self.visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_cancel") and visible:
		get_parent().get_node("Player").heal(2)

func _on_slot_1_button_pressed():
	get_parent().get_node("Player").upgrade(slots[0])
	cleanup()

func _on_slot_2_button_pressed():
	get_parent().get_node("Player").upgrade(slots[1])
	cleanup()

func _on_slot_3_button_pressed():
	get_parent().get_node("Player").upgrade(slots[2])
	cleanup()

func cleanup():
	slots = []
	self.visible = false
	get_tree().paused = false
	get_parent().menus.pop_front()
