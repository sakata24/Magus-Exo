extends CanvasLayer

var slots = []

const ART_PATH = "res://Resources/hud_elements/"
signal upgrade_chosen(upgrade)
signal heal_chosen(heal_value)

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
		var buff_name = ""
		# random upgrade
		var rand = randi_range(0, 11)
		match rand:
			0: 
				text = "Increase sunder damage by 10%"
				element = "sunder"
				buff_name = "sunder_dmg"
			1: 
				text = "Sunder spells gain another cast"
				element = "sunder"
				buff_name = "sunder_multicast"
			2: 
				text = "Increase entropy projectile speed by 10%"
				element = "entropy"
				buff_name = "entropy_spd"
			3: 
				text = "Increase entropy spell crit rate by 15%"
				element = "entropy"
				buff_name = "entropy_cr"
			4: 
				text = "Increase construct spell size by 10%"
				element = "construct"
				buff_name = "construct_size"
			5: 
				text = "Construct spells pass through walls"
				element = "construct"
				buff_name = "construct_passthru"
			6: 
				text = "Increase growth spell lifetime by 10%"
				element = "growth"
				buff_name = "growth_lifetime"
			7: 
				text = "Increase growth spell reaction potency by 10%"
				element = "growth"
				buff_name = "growth_rpotency"
			8: 
				text = "Reduce flow spell cooldowns by 10%"
				element = "flow"
				buff_name = "flow_cd"
			9: 
				text = "Increase flow spell size by 10%"
				element = "flow"
				buff_name = "flow_size"
			10: 
				text = "Increase wither spell lifetime by 10%"
				element = "wither"
				buff_name = "wither_lifetime"
			11: 
				text = "Increase wither spell size by 10%"
				element = "wither"
				buff_name = "wither_size"
			_: 
				text = str(rand)
				element = "sunder"
				buff_name = "none"
		get_node(str("HBoxContainer/Slot", i, "/VBoxContainer/Label")).text = text
		get_node(str("HBoxContainer/Slot", i, "/VBoxContainer/TextureRect")).texture = load(ART_PATH+element+"-card-sprite"+".png")
		if !get_node(str("HBoxContainer/Slot", i, "/VBoxContainer/TextureRect")).texture:
			get_node(str("HBoxContainer/Slot", i, "/VBoxContainer/TextureRect")).texture = load("res://Resources/icon.png")
		slots.push_back(buff_name)
		self.visible = true

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel") and visible:
		heal_chosen.emit(2)

func _on_slot_1_button_pressed():
	upgrade_chosen.emit(slots[0])
	cleanup()

func _on_slot_2_button_pressed():
	upgrade_chosen.emit(slots[1])
	cleanup()

func _on_slot_3_button_pressed():
	upgrade_chosen.emit(slots[3])
	cleanup()

func cleanup():
	slots = []
	self.visible = false
	get_tree().paused = false
	get_parent().menus.pop_front()
