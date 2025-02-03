extends TextureRect

class_name SkillIcon

signal select
signal equip

const ART_PATH = "res://Resources/icons/"

var spell : String


# Called when the node enters the scene tree for the first time.
func _ready():
	var scaleValue = size.y/500
	$ProgressBar.scale = Vector2(scaleValue,scaleValue)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func init(spl:String, text = ""):
	spell = spl
	$Label.text = text
	$ProgressBar.max_value = SkillDataHandler._get_ability(spl)["cooldown"]
	_get_icon()


func _get_icon():
	texture = load(ART_PATH+spell+".png")
	if !texture:
		texture = load("res://Resources/icon.png")


func set_icon(spl:String, lab = $Label.text):
	spell = spl
	$ProgressBar.max_value = 10*SkillDataHandler._get_ability(spl)["cooldown"]
	$Label.text = lab
	_get_icon()


func empty():
	spell = ""
	texture = load("res://Resources/icons/default.png")


func _on_gui_input(event:InputEvent):
	if event is InputEventMouseButton and event.is_pressed():
		if  event.is_action_pressed("R-Click"):
			emit_signal("equip", self)
		else:
			emit_signal("select", self)
