extends CanvasLayer

var hudScale = 100 # hud scale default 100px

func _ready():
	pass

func _set_xp(xp, max_xp):
	$EXPLabel.text = ("EXP: " + str(xp) + "/" + str(max_xp))

func set_lvl(lvl):
	$LVLLabel.text = ("Level: " + str(lvl))

func _set_cd(skill_cds, skill_cds_max):
	$Skill0/ProgressBar.set_size(Vector2((2*hudScale)-(skill_cds[0]*(2*hudScale)/skill_cds_max[0]),(0.35*hudScale)))
	$Skill1/ProgressBar.set_size(Vector2((2*hudScale)-(skill_cds[1]*(2*hudScale)/skill_cds_max[1]),(0.35*hudScale)))
	$Skill2/ProgressBar.set_size(Vector2((2*hudScale)-(skill_cds[2]*(2*hudScale)/skill_cds_max[2]),(0.35*hudScale)))
	$Skill3/ProgressBar.set_size(Vector2((2*hudScale)-(skill_cds[3]*(2*hudScale)/skill_cds_max[3]),(0.35*hudScale)))

func _set_hp(new_HP, max_HP):
	$Health/ProgressBar.set_size(Vector2((4*hudScale*new_HP)/max_HP,(0.35*hudScale)))
	$Health/HealthLabel.text = ("HEALTH: " + str(new_HP))

func _set_dash_cd(dash_cd, dash_cd_max):
	$Dash/ProgressBar.set_size(Vector2((4*hudScale)-(dash_cd*(4*hudScale)/dash_cd_max),(0.05*hudScale)))
