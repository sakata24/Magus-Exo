extends CanvasLayer


func _ready():
	pass

func _set_xp(xp, max_xp):
	$EXPLabel.text = ("EXP: " + str(xp) + "/" + str(max_xp))

func set_lvl(lvl):
	$LVLLabel.text = ("Level: " + str(lvl))

func _set_cd(skill_cds, skill_cds_max):
	$Skill0/ProgressBar.set_size(Vector2(200-(skill_cds[0]*200/skill_cds_max[0]),35))
	$Skill1/ProgressBar.set_size(Vector2(200-(skill_cds[1]*200/skill_cds_max[1]),35))
	$Skill2/ProgressBar.set_size(Vector2(200-(skill_cds[2]*200/skill_cds_max[2]),35))
	$Skill3/ProgressBar.set_size(Vector2(200-(skill_cds[3]*200/skill_cds_max[3]),35))

func _set_hp(newHP):
	$HealthLabel.text = ("HEALTH: " + str(newHP))
