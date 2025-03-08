extends MarginContainer

@onready var SkillCard = preload("res://HUDs/SkillCard.tscn")
@onready var SkillContainer = $ContentContainer/VBoxContainer/ScrollContainer/SkillContainer

var selectedElement
var selectedSpell : Dictionary

func _ready() -> void:
	$SubViewport/AnimationPlayer.play("ShopKeeperAnimation")
	
	#Set EXP values
	print("Player exp values: " + str(PersistentData.get_xp_counts()))
	for xpDisplay in $ContentContainer/VBoxContainer/HBoxContainer/VBoxContainer/ExpContainer.get_children():
		var xpValue : int = PersistentData.get_xp_counts()[xpDisplay.name + "_xp"]
		xpDisplay.text = str(xpValue)
	
	#Spawn Spell Cards
	var playerUnlockedSkills : Array = PersistentData.get_unlocked_skills()
	for skill in PlayerSkills.ALL_SKILLS.skills.values():
		var inst = SkillCard.instantiate()
		inst.set_spell_info(skill.name, skill.element, skill.description)
		SkillContainer.add_child(inst)
		inst.connect("selected", _select_spell)
		if playerUnlockedSkills.has(skill.name):
			inst.set_owned()

func _select_spell(data : Dictionary, icon : CompressedTexture2D):
	selectedSpell = data
	if !icon:
		$ContentContainer/VBoxContainer/HBoxContainer/HBoxContainer/SpellDescription.text = ""
		$ContentContainer/VBoxContainer/HBoxContainer/HBoxContainer/VBoxContainer2/TitleSpellIcon.texture = null
		$ContentContainer/VBoxContainer/HBoxContainer/HBoxContainer/VBoxContainer2/CostLabel.text = ""
		$ContentContainer/VBoxContainer/LearnButton.disabled = true
	else :
		$ContentContainer/VBoxContainer/HBoxContainer/HBoxContainer/SpellDescription.text = data.description
		var expAmount = PersistentData.get_xp_counts().get(data.element + "_xp")
		var spellCost = PlayerSkills.ALL_SKILLS.skills.get(data.name).get("price")
		
		$ContentContainer/VBoxContainer/HBoxContainer/HBoxContainer/VBoxContainer2/TitleSpellIcon.texture = icon
		$ContentContainer/VBoxContainer/HBoxContainer/HBoxContainer/VBoxContainer2/CostLabel.text = "Cost: " + str(spellCost)
		if (expAmount > spellCost):
			$ContentContainer/VBoxContainer/LearnButton.disabled = true
		else:
			$ContentContainer/VBoxContainer/LearnButton.disabled = false
		



func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("L-Click"):
		_select_spell({}, null)


func _button_pressed(element: String):
	selectedElement = element
	for button in $ContentContainer/VBoxContainer/HBoxContainer/VBoxContainer/ExpContainer.get_children():
		if button.name != element:
			button.button_pressed = false
	_sort_spells(element)


func _sort_spells(element : String):
	if element == "":
		for card in $ContentContainer/VBoxContainer/ScrollContainer/SkillContainer.get_children():
			card.visible = true
	else:
		for card in $ContentContainer/VBoxContainer/ScrollContainer/SkillContainer.get_children():
			if card.spellData.element == element:
				card.visible = true
			else:
				card.visible = false

func _on_sunder_toggled(toggled_on: bool) -> void:
	_select_spell({}, null)
	if toggled_on:
		_button_pressed("sunder")
	else:
		if selectedElement == "sunder":
			_sort_spells("")


func _on_entropy_toggled(toggled_on: bool) -> void:
	_select_spell({}, null)
	if toggled_on:
		_button_pressed("entropy")
	else:
		if selectedElement == "entropy":
			_sort_spells("")


func _on_growth_toggled(toggled_on: bool) -> void:
	_select_spell({}, null)
	if toggled_on:
		_button_pressed("growth")
	else:
		if selectedElement == "growth":
			_sort_spells("")


func _on_construct_toggled(toggled_on: bool) -> void:
	_select_spell({}, null)
	if toggled_on:
		_button_pressed("construct")
	else:
		if selectedElement == "construct":
			_sort_spells("")


func _on_flow_toggled(toggled_on: bool) -> void:
	_select_spell({}, null)
	if toggled_on:
		_button_pressed("flow")
	else:
		if selectedElement == "flow":
			_sort_spells("")


func _on_wither_toggled(toggled_on: bool) -> void:
	_select_spell({}, null)
	if toggled_on:
		_button_pressed("wither")
	else:
		if selectedElement == "wither":
			_sort_spells("")


func _on_learn_button_pressed() -> void:
	#Set the text
	$Popup/MarginContainer/VBoxContainer/LearnConfirmLabel.text = "[center]Learn [color=" + AbilityColor.get_color_by_string(selectedSpell.element).to_html(false) + "]" + selectedSpell.name + "[/color] for " + str(PlayerSkills.ALL_SKILLS.skills.get(selectedSpell.name).get("price")) + " xp?"
	
	$Popup.visible = true


func _on_no_button_pressed() -> void:
	$Popup.visible = false


func _on_yes_button_pressed() -> void:
	$Popup.visible = false
	# Subtract xp
	# Add to learned spells
	# Change to owned
	for spellCard in SkillContainer.get_children():
		if spellCard.spellData == selectedSpell:
			spellCard.set_owned()
			break
