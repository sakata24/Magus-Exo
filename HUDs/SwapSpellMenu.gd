extends CanvasLayer

@onready var SkillCard = preload("res://HUDs/Components/SkillCard.tscn")
@onready var SkillContainer = $ContentContainer/VBoxContainer/ScrollContainer/SkillContainer
@onready var HeaderSkillCards = [$ContentContainer/VBoxContainer/HBoxContainer/HeaderSkillCard,
$ContentContainer/VBoxContainer/HBoxContainer/HeaderSkillCard2,
$ContentContainer/VBoxContainer/HBoxContainer/HeaderSkillCard3,
$ContentContainer/VBoxContainer/HBoxContainer/HeaderSkillCard4]

var selectedEquipSlot := -1

func _ready() -> void:
	var playerUnlockedSkills : Array = PersistentData.get_unlocked_skills()
	var playerEquippedSkills : Array = PersistentData.get_equipped_skills()
	
	#Spawn Spell Cards
	for unlocked in playerUnlockedSkills:
		var skill = PlayerSkills.ALL_SKILLS.skills.get(unlocked)
		var inst = SkillCard.instantiate()
		inst.set_spell_info(skill.name, skill.element, skill.description)
		SkillContainer.add_child(inst)
		inst.connect("selected", _swap_spell)
		var isEquipped = playerEquippedSkills.find(skill.name)
		if isEquipped >= 0:
			inst.set_equipped(isEquipped)
	
	# Initialize equipped spells
	for i in 4:
		HeaderSkillCards[i].set_key(i)
		HeaderSkillCards[i].connect("selected", _select_equip_slot)
		HeaderSkillCards[i].set_ui(playerEquippedSkills[i])

func _swap_spell(spell:Control, texture):
	if selectedEquipSlot < 0:
		return
	var playerEquippedSkills : Array = PersistentData.get_equipped_skills()
	if not playerEquippedSkills.has(spell.spellData.name):
		# De-equip the current slot
		for i in SkillContainer.get_children():
			if i.equipped == selectedEquipSlot:
				i.set_unequipped()
		spell.set_equipped(selectedEquipSlot)
		PersistentData.equip_skill(spell.spellData.name, selectedEquipSlot)
		HeaderSkillCards[selectedEquipSlot].set_ui(spell.spellData.name)

func _select_equip_slot(idx : int):
	selectedEquipSlot = idx
	for i in 4:
		if i != idx:
			HeaderSkillCards[i].deselect()
