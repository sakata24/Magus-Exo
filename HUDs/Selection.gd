extends CanvasLayer

var slots = []

var construct_card = ImageTexture.create_from_image(Image.load_from_file("res://Resources/hud_elements/construct-card-sprite.png"))
var sunder_card = ImageTexture.create_from_image(Image.load_from_file("res://Resources/hud_elements/sunder-card-sprite.png"))
var entropy_card = ImageTexture.create_from_image(Image.load_from_file("res://Resources/hud_elements/entropy-card-sprite.png"))
var flow_card = ImageTexture.create_from_image(Image.load_from_file("res://Resources/hud_elements/flow-card-sprite.png"))

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func setup():
	get_tree().paused = true
	get_parent()._add_menu(self)
	# loop thru card slots
	for i in range(1, 4):
		var text = ""
		var img = sunder_card
		# random upgrade
		var rand = randi_range(0, 11)
		match rand:
			0: 
				text = "Increase sunder damage by 10%"
				img = sunder_card
			1: 
				text = "Sunder spells gain another cast"
				img = sunder_card
			2: 
				text = "Increase entropy projectile speed by 10%"
				img = entropy_card
			3: 
				text = "Increase entropy spell crit rate by 15%"
				img = entropy_card
			4: 
				text = "Increase construct spell size by 10%"
				img = construct_card
			5: 
				text = "Construct spells pass through walls"
				img = construct_card
			6: 
				text = "Increase growth spell lifetime by 10%"
			7: 
				text = "Increase growth spell reaction potency by 10%"
			8: 
				text = "Reduce flow spell cooldowns by 10%"
				img = flow_card
			9: 
				text = "Increase flow spell size by 10%"
				img = flow_card
			10: 
				text = "Increase wither spell lifetime by 10%"
			11: 
				text = "Increase wither spell size by 10%"
			_: 
				text = str(rand)
				img = construct_card
		get_node(str("HBoxContainer/Slot", i, "/VBoxContainer/Label")).text = text
		get_node(str("HBoxContainer/Slot", i, "/VBoxContainer/TextureRect")).texture = img
		slots.push_back(rand)
		self.visible = true

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
	get_tree().paused = false
	get_parent().menus.pop_front()
