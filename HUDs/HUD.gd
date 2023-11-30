extends CanvasLayer


func _ready():
	pass

func init(health, xp, max_xp, skill1, skill2, skill3, skill4):
	_set_health(health)
	_set_xp(xp,max_xp)
	set_lvl(0)
	_set_skills(skill1,skill2,skill3,skill4)
	pass

func _set_health(hp):
	$HealthLabel.text = ("Health: " + str(hp))

func _set_xp(xp, max_xp):
	$EXPLabel.text = ("EXP: " + str(xp) + "/" + str(max_xp))

func set_lvl(lvl):
	$LVLLabel.text = ("Level: " + str(lvl))

func _set_skills(one,two,three,four):
	$Skill/Ability1/HBoxContainer/SkillName.text = one
	$Skill/Ability2/HBoxContainer/SkillName.text = two
	$Skill/Ability3/HBoxContainer/SkillName.text = three
	$Skill/Ability4/HBoxContainer/SkillName.text = four
	$Skill/Ability1/HBoxContainer/SkillIcon.set_icon(one)
	$Skill/Ability2/HBoxContainer/SkillIcon.set_icon(two)
	$Skill/Ability3/HBoxContainer/SkillIcon.set_icon(three)
	$Skill/Ability4/HBoxContainer/SkillIcon.set_icon(four)

func _set_cd(skill_cds, skill_cds_max):
#	$VBoxContainer/Ability1/HBoxContainer/SkillIcon/ProgressBar.value
	pass
