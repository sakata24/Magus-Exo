extends CanvasLayer

var hudScale = 100

func _ready():
	_set_ui_size()
	_hide_ability_names()

func init(health, max_health, xp, max_xp, skill1, skill2, skill3, skill4):
	_set_health(health, max_health)
	_set_xp(xp,max_xp)
	set_lvl(0)
	_set_skills(skill1,skill2,skill3,skill4)

func _set_health(new_HP, max_HP):
	$Health/ProgressBar.set_size(Vector2((4*hudScale*new_HP)/max_HP,(0.35*hudScale)))
	$Health/HealthLabel.text = ("HEALTH: " + str(new_HP))

func _set_dash_cd(dash_cd, dash_cd_max):
	$Dash/ProgressBar.set_size(Vector2((4*hudScale)-(dash_cd*(4*hudScale)/dash_cd_max),(0.05*hudScale)))

func _set_xp(xp, max_xp):
	$EXPLabel.text = ("EXP: " + str(xp) + " /" + str(max_xp))

func set_lvl(lvl):
	$LVLLabel.text = ("Level: " + str(lvl))

func _set_skills(one,two,three,four):
	$Skill/Ability1/HBoxContainer/SkillName.text = one
	$Skill/Ability2/HBoxContainer/SkillName.text = two
	$Skill/Ability3/HBoxContainer/SkillName.text = three
	$Skill/Ability4/HBoxContainer/SkillName.text = four
	$Skill/Ability1/HBoxContainer/SkillMargin/SkillIcon.set_icon(one,"Q")
	$Skill/Ability2/HBoxContainer/SkillMargin/SkillIcon.set_icon(two,"W")
	$Skill/Ability3/HBoxContainer/SkillMargin/SkillIcon.set_icon(three,"E")
	$Skill/Ability4/HBoxContainer/SkillMargin/SkillIcon.set_icon(four,"R")

func _set_cd(skill_cds, skill_cds_max):
	$Skill/Ability1/HBoxContainer/SkillMargin/SkillIcon/ProgressBar.value = skill_cds_max[0]-skill_cds[0]
	$Skill/Ability2/HBoxContainer/SkillMargin/SkillIcon/ProgressBar.value = skill_cds_max[1]-skill_cds[1]
	$Skill/Ability3/HBoxContainer/SkillMargin/SkillIcon/ProgressBar.value = skill_cds_max[2]-skill_cds[2]
	$Skill/Ability4/HBoxContainer/SkillMargin/SkillIcon/ProgressBar.value = skill_cds_max[3]-skill_cds[3]

func _set_ui_size():
	$Skill.size.y = DisplayServer.window_get_size().y/3
	$Skill.position.y = DisplayServer.window_get_size().y/2-$Skill.size.y/2
	$Skill.position.x = 10
	$Skill.size.x = $Skill.size.y*0.75
	var boxSize = ($Skill.size.y-(3*15))/4
	for n in $Skill.get_children():
		n.get_node("HBoxContainer/Control/ColorRect").size.x = boxSize + 2
		n.get_node("HBoxContainer/Control/ColorRect").size.y = boxSize + 2
		n.get_node("HBoxContainer/SkillMargin/SkillIcon/ProgressBar").scale = Vector2(boxSize/500, boxSize/500)

func _show_ability_names():
	for n in $Skill.get_children():
		n.get_node("Body").visible = true
		n.get_node("HBoxContainer/SkillName").self_modulate = Color(1,1,1,1)


func _hide_ability_names():
	for n in $Skill.get_children():
		n.get_node("Body").visible = false
		n.get_node("HBoxContainer/SkillName").self_modulate = Color(1,1,1,0)
