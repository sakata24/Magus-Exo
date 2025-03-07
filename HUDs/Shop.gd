extends MarginContainer

@onready var SkillCard = preload("res://HUDs/SkillCard.tscn")
@onready var SkillContainer = $ContentContainer/VBoxContainer/ScrollContainer/SkillContainer

var selectedSpell
var selectedElement

func _ready() -> void:
	$SubViewport/AnimationPlayer.play("ShopKeeperAnimation")
	var playerUnlockedSkills : Array = PersistentData.get_unlocked_skills()
	for skill in PlayerSkills.ALL_SKILLS.skills.values():
		var inst = SkillCard.instantiate()
		inst.set_spell_info(skill.name, skill.element, skill.description)
		SkillContainer.add_child(inst)
		inst.connect("selected", _select_spell)
		if playerUnlockedSkills.has(skill.name):
			inst.set_owned()

func _select_spell(description : String, icon : CompressedTexture2D):
	$ContentContainer/VBoxContainer/HBoxContainer/SpellDescription.text = description
	if !icon:
		$ContentContainer/VBoxContainer/HBoxContainer/TitleSpellIcon.texture = null
	else :
		$ContentContainer/VBoxContainer/HBoxContainer/TitleSpellIcon.texture = icon


func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("L-Click"):
		_select_spell("", null)


func _on_xp_button_toggled(toggled_on: bool) -> void:
	if not toggled_on:
		_sort_spells("")


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
			if card.spellElement == element:
				card.visible = true
			else:
				card.visible = false

func _on_sunder_toggled(toggled_on: bool) -> void:
	if toggled_on:
		_button_pressed("sunder")
	else:
		if selectedElement == "sunder":
			_sort_spells("")


func _on_entropy_toggled(toggled_on: bool) -> void:
	if toggled_on:
		_button_pressed("entropy")
	else:
		if selectedElement == "entropy":
			_sort_spells("")


func _on_growth_toggled(toggled_on: bool) -> void:
	if toggled_on:
		_button_pressed("growth")
	else:
		if selectedElement == "growth":
			_sort_spells("")


func _on_construct_toggled(toggled_on: bool) -> void:
	if toggled_on:
		_button_pressed("construct")
	else:
		if selectedElement == "construct":
			_sort_spells("")


func _on_flow_toggled(toggled_on: bool) -> void:
	if toggled_on:
		_button_pressed("flow")
	else:
		if selectedElement == "flow":
			_sort_spells("")


func _on_wither_toggled(toggled_on: bool) -> void:
	if toggled_on:
		_button_pressed("wither")
	else:
		if selectedElement == "wither":
			_sort_spells("")
