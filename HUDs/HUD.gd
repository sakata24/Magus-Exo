class_name HUD extends CanvasLayer

var hudScale = 100

@onready var bottom_progress_bar_max = $BottomHUD/HealthBar.size.x
@onready var health_bar = $BottomHUD/HealthBar
@onready var health_label = $BottomHUD/HealthLabel
@onready var dash_bar = $BottomHUD/DashBar

func _ready():
	_set_ui_size()

func init(health, max_health, skills):
	_set_health(health, max_health)
	set_floor(0)
	_set_skills(skills)

func on_hud_size_changed():
	pass
	# change hud size

func _set_health(new_HP, max_HP):
	health_bar.set_size(Vector2(bottom_progress_bar_max * float(float(new_HP) / float(max_HP)),(health_bar.size.y)))
	health_label.text = ("HEALTH: " + str(new_HP))

func _set_dash_cd(dash_cd, dash_cd_max):
	dash_bar.set_size(Vector2(bottom_progress_bar_max - (bottom_progress_bar_max * float(float(dash_cd) / float(dash_cd_max))),(dash_bar.size.y)))

func _set_skills(skills: Array):
	$Skill/Ability1/HBoxContainer/SkillName.text = skills[0]
	$Skill/Ability2/HBoxContainer/SkillName.text = skills[1]
	$Skill/Ability3/HBoxContainer/SkillName.text = skills[2]
	$Skill/Ability4/HBoxContainer/SkillName.text = skills[3]
	$Skill/Ability1/HBoxContainer/Border/SkillIcon.set_icon(skills[0],"Q")
	$Skill/Ability2/HBoxContainer/Border/SkillIcon.set_icon(skills[1],"W")
	$Skill/Ability3/HBoxContainer/Border/SkillIcon.set_icon(skills[2],"E")
	$Skill/Ability4/HBoxContainer/Border/SkillIcon.set_icon(skills[3],"R")

func _set_cd(skill_cds, skill_cds_max):
	$Skill/Ability1/HBoxContainer/Border/SkillIcon/ProgressBar.value = skill_cds_max[0]-skill_cds[0]
	$Skill/Ability2/HBoxContainer/Border/SkillIcon/ProgressBar.value = skill_cds_max[1]-skill_cds[1]
	$Skill/Ability3/HBoxContainer/Border/SkillIcon/ProgressBar.value = skill_cds_max[2]-skill_cds[2]
	$Skill/Ability4/HBoxContainer/Border/SkillIcon/ProgressBar.value = skill_cds_max[3]-skill_cds[3]

func _set_ui_size():
	$Skill.size.y = get_viewport().get_visible_rect().size.y/3
	$Skill.position.y = get_viewport().get_visible_rect().size.y/2-$Skill.size.y/2
	$Skill.position.x = 10
	$Skill.size.x = $Skill.size.y*0.75
	var boxSize = ($Skill.size.y-(3*15))/4

func set_floor(i : int):
	$FloorLabel.text = "Floor: " + str(i)

func show_boss_bar(n : String, health : int):
	$MarginContainer/BossBar/Label.text = n
	$MarginContainer/BossBar/ProgressBar.max_value = health
	$MarginContainer/BossBar/ProgressBar.value = health
	$MarginContainer/BossBar.visible = true

func hide_boss_bar():
	$MarginContainer/BossBar.visible = false

func _on_boss_health_change(newHealth : int, immune = false):
	$MarginContainer/BossBar/ProgressBar/Label.text = str($MarginContainer/BossBar/ProgressBar.value) + "/" + str($MarginContainer/BossBar/ProgressBar.max_value)
	$MarginContainer/BossBar/ProgressBar.value = newHealth
	if immune:
		$MarginContainer/BossBar/ProgressBar.self_modulate = Color.WEB_GRAY
		$MarginContainer/BossBar/ProgressBar.show_percentage = false
	else:
		$MarginContainer/BossBar/ProgressBar.show_percentage = true
		$MarginContainer/BossBar/ProgressBar.self_modulate = Color(1,0,0,1)
