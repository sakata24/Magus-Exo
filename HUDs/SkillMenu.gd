extends CanvasLayer

@onready var Icon = preload("res://Resources/hud_elements/SkillIcon.tscn")
@onready var SpellContainer = $Control/HBoxContainer/ColorRect2/LeftMargin/Left/SpellContainer
@onready var Details = $Control/HBoxContainer/Right/RightContainer/DetailsMargin/SkillDetails
@onready var EquipContainer = $Control/HBoxContainer/Right/RightContainer/EquipMargin/EquippedAbilities

var dict


# Called when the node enters the scene tree for the first time.
func _ready():
	var file = FileAccess.open("res://Resources/abilitysheet.txt", FileAccess.READ)
	dict = SkillDataHandler.get_skills()
#	print_dictionary()
	file.close()
	$Control/HBoxContainer/Right/RightContainer/EquipMargin/EquippedAbilities/Ability1/Label.text = "Q"
	$Control/HBoxContainer/Right/RightContainer/EquipMargin/EquippedAbilities/Ability2/Label.text = "W"
	$Control/HBoxContainer/Right/RightContainer/EquipMargin/EquippedAbilities/Ability3/Label.text = "E"
	$Control/HBoxContainer/Right/RightContainer/EquipMargin/EquippedAbilities/Ability4/Label.text = "R"
	_draw_icons()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _draw_icons():
	for n in dict:
		var instance = Icon.instantiate()
		instance.init(n)
		instance.connect("equip", _equip_skill)
		instance.connect("select", _select_skill)
		SpellContainer.add_child(instance)


func print_dictionary():
	for n in dict:
		print(SkillDataHandler._get_ability(n))

func _select_skill(skill:SkillIcon):
	Details.get_node("PhotoContainer/DetailIcon").texture = skill.texture
	var skillInfo = SkillDataHandler._get_ability(skill.spell)
	Details.get_node("name/Value").text = skillInfo.name
	Details.get_node("cooldown/Value").text = str(skillInfo.cooldown)
	Details.get_node("dmg/Value").text = str(skillInfo.dmg)
	Details.get_node("element/Value").text = skillInfo.element
	Details.get_node("lifetime/Value").text = str(skillInfo.lifetime)
	Details.get_node("size/Value").text = str(skillInfo.size)
	Details.get_node("speed/Value").text = str(skillInfo.speed)
	Details.get_node("timeout/Value").text = str(skillInfo.timeout)
	Details.get_node("type/Value").text = skillInfo.type


func _equip_skill(skill:SkillIcon):
	#Check if already equipped -> remove
	var skillInfo = SkillDataHandler._get_ability(skill.spell)
	for n in EquipContainer.get_children():
		if n.spell == skillInfo.name:
			n.empty()
			return
	#Check for empty skill slot
	for n in EquipContainer.get_children():
		if n.spell == "":
			n.set_icon(skill.spell)
			return
