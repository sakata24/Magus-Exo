class_name StageMaster extends Boss

enum {LEFT, RIGHT}

var which_hand : int
var center_marker : Marker2D
var stage = 0
var invincible : bool = true
var getting_into_position := false

signal in_position

func _ready() -> void:
	# Set boss/monster variables
	maxHealth = 500
	speed = 300
	boss_name = "The Stage Master"
	aggro = true
	# Set stage master properties/variables
	$AnimationPlayer.play("idle")
	super._ready()

func sm_init(hand : int, mark : Marker2D):
	which_hand = hand
	center_marker = mark
	connect("in_position", get_parent().set_getting_in_position)

func _physics_process(delta: float) -> void:
	if getting_into_position:
		super(delta)

func start():
	$StateMachine/Idle.start_selection()

# hit by something
func _hit(damage: DamageObject):
	super(damage)

func flip(side : bool):
	$Sprite2D.flip_v = side

func _on_navigation_agent_2d_target_reached() -> void:
	if getting_into_position:
		emit_signal("in_position", which_hand)
		getting_into_position = false
		$NavigationAgent2D.target_position = Vector2(0,0)
